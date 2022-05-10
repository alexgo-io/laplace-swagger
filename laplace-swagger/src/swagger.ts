import axios from 'axios';
import * as fs from 'fs';
import * as path from 'path';
import { HASURA_HOST, X_HASURA_ADMIN_SECRET } from './config/secret';

async function fetchApi() {
  const HASURA_SWAGGER_ENDPOINT = HASURA_HOST + '/api/swagger/json';

  const response = await axios({
    method: 'get',
    url: HASURA_SWAGGER_ENDPOINT,
    headers: {
      'Content-Type': 'application/json',
      'x-hasura-role': 'admin',
      'x-hasura-admin-secret': X_HASURA_ADMIN_SECRET,
    },
  });

  const genDir = path.resolve(__dirname, './generated');

  const swaggerJson = JSON.stringify(response.data);
  fs.writeFileSync(genDir + '/swagger.json', swaggerJson);
}

fetchApi().catch(console.error);
