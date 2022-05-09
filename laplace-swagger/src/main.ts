import crossFetch from 'cross-fetch';
import { GraphQLClient } from 'graphql-request';
import http from 'http';
import { YQueue } from 'yqueue';
import { setupConfigTable } from './config-table';
import {
  HASURA_GRAPHQL_ENDPOINT,
  X_HASURA_ADMIN_SECRET,
} from './config/secret';
import logger from './logger';
import { Poller } from './poller';

(BigInt.prototype as any).toJSON = function () {
  return this.toString();
};

async function start() {
  const HASURA_REQUEST_CONCURRENCY_LIMIT = parseInt(
    process.env.HASURA_REQUEST_CONCURRENCY_LIMIT ?? '32',
    10,
  );
  const queue = new YQueue({
    concurrency: HASURA_REQUEST_CONCURRENCY_LIMIT,
  });
  const fetch: typeof crossFetch = (input, init) =>
    queue.run(async () => {
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
    });
  const gql = new GraphQLClient(HASURA_GRAPHQL_ENDPOINT, {
    headers: {
      'x-hasura-role': 'admin',
      'x-hasura-admin-secret': X_HASURA_ADMIN_SECRET,
    },
    fetch,
  });

  await setupConfigTable(gql);

  const poller = new Poller(gql);
  poller.start();

  const requestListener: http.RequestListener = function (_, res) {
    // Health check for cloud run
    res.writeHead(200);
    res.end('Laplace Sync');
  };
  const server = http.createServer(requestListener);

  const port = process.env.PORT || 3702;

  server.listen(port, () => {
    logger.info(`laplace sync started at port ${port}`);
  });
}

start().catch(console.error);
