import safeJsonStringify from 'safe-json-stringify';
import { STACKS_DEPLOYER_ADDRESS } from '../config/stacks';
import { smoke } from '../testing/smoke';
import { alexPrincipal, useContract } from './contracts';

const it = smoke(__filename);

const ALEX = alexPrincipal('age000-governance-token');
const STX = alexPrincipal('token-wstx');

describe('Smoke test for contracts', () => {
  it('try to get alex reserved', async () => {
    await new Promise(f => setTimeout(f));
    const rs = await useContract('alex-reserve-pool').map('reserve').get(ALEX);
    console.log('Reserved alex:', rs);
  }, 86400000);
  it('try to get alex coinbase', async () => {
    await new Promise(f => setTimeout(f));
    const rs = await useContract('alex-reserve-pool')
      .map('coinbase-amounts')
      .get(ALEX);
    console.log('Reserved alex:', rs);
  }, 86400000);
  it('get apower multiplier through ro', async () => {
    await new Promise(f => setTimeout(f));
    const rs = await useContract('alex-reserve-pool')
      .func('get-apower-multiplier-in-fixed-or-default')
      .call(STACKS_DEPLOYER_ADDRESS, {
        token: ALEX,
      });
    console.log('Alex apower multiplier:', rs);
  });
  it('try to get alex staking at cycle', async () => {
    await new Promise(f => setTimeout(f));
    const rs = await useContract('alex-reserve-pool')
      .map('staking-stats-at-cycle')
      .get({
        token: ALEX,
        'reward-cycle': 14n,
      });
    console.log('alex staking at cycle 14:', rs);
  }, 86400000);
  it('swp', async () => {
    await new Promise(f => setTimeout(f));
    const poolData = await useContract('simple-weight-pool-alex')
      .map('pools-data-map')
      .get({
        'token-x': alexPrincipal('age000-governance-token'),
        'token-y': alexPrincipal('token-wban'),
      });
    console.log(poolData ? safeJsonStringify(poolData, null, 2) : 'null');
  }, 86400000);
  it('fwp', async () => {
    await new Promise(f => setTimeout(f));
    const poolData = await useContract('fixed-weight-pool-v1-01')
      .map('pools-data-map')
      .get({
        'token-x': STX,
        'token-y': alexPrincipal('token-wbtc'),
        'weight-x': 50000000n,
        'weight-y': 50000000n,
      });
    console.log(poolData ? safeJsonStringify(poolData, null, 2) : 'null');
  }, 86400000);
  it('auto alex total-supply', async () => {
    await new Promise(f => setTimeout(f));
    const rs = await useContract('auto-alex').data('total-supply').get();
    console.log('Reserved alex:', rs);
  }, 86400000);
});
