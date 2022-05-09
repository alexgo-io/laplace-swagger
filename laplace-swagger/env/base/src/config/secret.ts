export const X_HASURA_ADMIN_SECRET =
  process.env['X_HASURA_ADMIN_SECRET'] ?? '{{X_HASURA_ADMIN_SECRET}}';
export const HASURA_HOST = process.env['HASURA_HOST'] ?? '{{HASURA_HOST}}';
export const HASURA_GRAPHQL_ENDPOINT = HASURA_HOST + '/v1/graphql';
