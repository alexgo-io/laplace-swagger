import crossFetch from 'cross-fetch';
import { GraphQLClient } from 'graphql-request';
import {
  HASURA_GRAPHQL_ENDPOINT,
  X_HASURA_ADMIN_SECRET,
} from './config/secret';
import logger from './logger';
import { smoke } from './testing/smoke';
const it = smoke(__filename);

describe('Testing GraphQL Request', () => {
  it('Testing GraphQL Request', async () => {
    const fetch: typeof crossFetch = async (input, init) => {
      const controller = new AbortController();
      let timeoutId: ReturnType<typeof setTimeout> | null = setTimeout(() => {
        logger.warn(`Graphql request timeout`);
        timeoutId = null;
        controller.abort();
      }, 30000);
      try {
        return await crossFetch(input, { ...init, signal: controller.signal });
      } finally {
        timeoutId && clearTimeout(timeoutId);
      }
    };
    const gql = new GraphQLClient(HASURA_GRAPHQL_ENDPOINT, {
      headers: {
        'x-hasura-role': 'admin',
        'x-hasura-admin-secret': X_HASURA_ADMIN_SECRET,
      },
      fetch,
    });
    expect(gql).toBeDefined();
  });
});
