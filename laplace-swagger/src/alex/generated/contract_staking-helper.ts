import {
  defineContract,
  listT,
  numberT,
  principalT,
  responseSimpleT,
  tupleT,
} from 'clarity-codegen';

export const stakingHelper = defineContract({
  'staking-helper': {
    'claim-staking-reward': {
      input: [
        { name: 'token', type: principalT },
        { name: 'reward-cycles', type: listT(numberT) },
      ],
      output: responseSimpleT(
        listT(
          responseSimpleT(
            tupleT({ 'entitled-token': numberT, 'to-return': numberT }),
          ),
        ),
      ),
      mode: 'public',
    },
    'claim-staking-reward-by-tx-sender': {
      input: [
        { name: 'token', type: principalT },
        { name: 'reward-cycle', type: numberT },
      ],
      output: responseSimpleT(
        tupleT({ 'entitled-token': numberT, 'to-return': numberT }),
      ),
      mode: 'public',
    },
    'get-staked': {
      input: [
        { name: 'token', type: principalT },
        { name: 'reward-cycles', type: listT(numberT) },
      ],
      output: listT(tupleT({ 'amount-staked': numberT, 'to-return': numberT })),
      mode: 'readonly',
    },
    'get-staking-rewards': {
      input: [
        { name: 'token', type: principalT },
        { name: 'reward-cycles', type: listT(numberT) },
      ],
      output: listT(numberT),
      mode: 'readonly',
    },
    'get-staking-stats-coinbase': {
      input: [
        { name: 'token', type: principalT },
        { name: 'reward-cycle', type: numberT },
      ],
      output: tupleT({ 'coinbase-amount': numberT, 'staking-stats': numberT }),
      mode: 'readonly',
    },
    'get-staking-stats-coinbase-as-list': {
      input: [
        { name: 'token', type: principalT },
        { name: 'reward-cycles', type: listT(numberT) },
      ],
      output: listT(
        tupleT({ 'coinbase-amount': numberT, 'staking-stats': numberT }),
      ),
      mode: 'readonly',
    },
  },
} as const);
