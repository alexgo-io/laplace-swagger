import {
  booleanT,
  defineContract,
  noneT,
  numberT,
  optionalT,
  principalT,
  responseSimpleT,
  tupleT,
} from 'clarity-codegen';

export const alexReservePool = defineContract({
  'alex-reserve-pool': {
    'add-approved-contract': {
      input: [{ name: 'new-approved-contract', type: principalT }],
      output: responseSimpleT(booleanT),
      mode: 'public',
    },
    'add-to-balance': {
      input: [
        { name: 'token', type: principalT },
        { name: 'amount', type: numberT },
      ],
      output: responseSimpleT(booleanT),
      mode: 'public',
    },
    'add-token': {
      input: [{ name: 'token', type: principalT }],
      output: responseSimpleT(booleanT),
      mode: 'public',
    },
    'claim-staking-reward': {
      input: [
        { name: 'token-trait', type: principalT },
        { name: 'target-cycle', type: numberT },
      ],
      output: responseSimpleT(
        tupleT({ 'entitled-token': numberT, 'to-return': numberT }),
      ),
      mode: 'public',
    },
    'remove-from-balance': {
      input: [
        { name: 'token', type: principalT },
        { name: 'amount', type: numberT },
      ],
      output: responseSimpleT(booleanT),
      mode: 'public',
    },
    'set-activation-block': {
      input: [
        { name: 'token', type: principalT },
        { name: 'new-activation-block', type: numberT },
      ],
      output: responseSimpleT(booleanT),
      mode: 'public',
    },
    'set-apower-multiplier-in-fixed': {
      input: [
        { name: 'token', type: principalT },
        { name: 'new-apower-multiplier-in-fixed', type: numberT },
      ],
      output: responseSimpleT(booleanT),
      mode: 'public',
    },
    'set-coinbase-amount': {
      input: [
        { name: 'token', type: principalT },
        { name: 'coinbase-1', type: numberT },
        { name: 'coinbase-2', type: numberT },
        { name: 'coinbase-3', type: numberT },
        { name: 'coinbase-4', type: numberT },
        { name: 'coinbase-5', type: numberT },
      ],
      output: responseSimpleT(booleanT),
      mode: 'public',
    },
    'set-contract-owner': {
      input: [{ name: 'owner', type: principalT }],
      output: responseSimpleT(booleanT),
      mode: 'public',
    },
    'set-reward-cycle-length': {
      input: [{ name: 'new-reward-cycle-length', type: numberT }],
      output: responseSimpleT(booleanT),
      mode: 'public',
    },
    'set-token-halving-cycle': {
      input: [{ name: 'new-token-halving-cycle', type: numberT }],
      output: responseSimpleT(booleanT),
      mode: 'public',
    },
    'stake-tokens': {
      input: [
        { name: 'token-trait', type: principalT },
        { name: 'amount-token', type: numberT },
        { name: 'lock-period', type: numberT },
      ],
      output: responseSimpleT(booleanT),
      mode: 'public',
    },
    'get-activation-block-or-default': {
      input: [{ name: 'token', type: principalT }],
      output: numberT,
      mode: 'readonly',
    },
    'get-apower-multiplier-in-fixed-or-default': {
      input: [{ name: 'token', type: principalT }],
      output: numberT,
      mode: 'readonly',
    },
    'get-balance': {
      input: [{ name: 'token', type: principalT }],
      output: numberT,
      mode: 'readonly',
    },
    'get-coinbase-amount-or-default': {
      input: [
        { name: 'token', type: principalT },
        { name: 'reward-cycle', type: numberT },
      ],
      output: numberT,
      mode: 'readonly',
    },
    'get-coinbase-thresholds': {
      input: [],
      output: responseSimpleT(
        tupleT({
          'coinbase-threshold-1': numberT,
          'coinbase-threshold-2': numberT,
          'coinbase-threshold-3': numberT,
          'coinbase-threshold-4': numberT,
          'coinbase-threshold-5': numberT,
        }),
      ),
      mode: 'readonly',
    },
    'get-contract-owner': {
      input: [],
      output: responseSimpleT(principalT),
      mode: 'readonly',
    },
    'get-first-stacks-block-in-reward-cycle': {
      input: [
        { name: 'token', type: principalT },
        { name: 'reward-cycle', type: numberT },
      ],
      output: numberT,
      mode: 'readonly',
    },
    'get-registered-users-nonce': {
      input: [{ name: 'token', type: principalT }],
      output: optionalT(numberT),
      mode: 'readonly',
    },
    'get-registered-users-nonce-or-default': {
      input: [{ name: 'token', type: principalT }],
      output: numberT,
      mode: 'readonly',
    },
    'get-reward-cycle': {
      input: [
        { name: 'token', type: principalT },
        { name: 'stacks-height', type: numberT },
      ],
      output: optionalT(numberT),
      mode: 'readonly',
    },
    'get-reward-cycle-length': { input: [], output: numberT, mode: 'readonly' },
    'get-staker-at-cycle': {
      input: [
        { name: 'token', type: principalT },
        { name: 'reward-cycle', type: numberT },
        { name: 'user-id', type: numberT },
      ],
      output: optionalT(
        tupleT({ 'amount-staked': numberT, 'to-return': numberT }),
      ),
      mode: 'readonly',
    },
    'get-staker-at-cycle-or-default': {
      input: [
        { name: 'token', type: principalT },
        { name: 'reward-cycle', type: numberT },
        { name: 'user-id', type: numberT },
      ],
      output: tupleT({ 'amount-staked': numberT, 'to-return': numberT }),
      mode: 'readonly',
    },
    'get-staking-reward': {
      input: [
        { name: 'token', type: principalT },
        { name: 'user-id', type: numberT },
        { name: 'target-cycle', type: numberT },
      ],
      output: numberT,
      mode: 'readonly',
    },
    'get-staking-stats-at-cycle': {
      input: [
        { name: 'token', type: principalT },
        { name: 'reward-cycle', type: numberT },
      ],
      output: optionalT(numberT),
      mode: 'readonly',
    },
    'get-staking-stats-at-cycle-or-default': {
      input: [
        { name: 'token', type: principalT },
        { name: 'reward-cycle', type: numberT },
      ],
      output: numberT,
      mode: 'readonly',
    },
    'get-token-halving-cycle': { input: [], output: numberT, mode: 'readonly' },
    'get-user': {
      input: [
        { name: 'token', type: principalT },
        { name: 'user-id', type: numberT },
      ],
      output: optionalT(principalT),
      mode: 'readonly',
    },
    'get-user-id': {
      input: [
        { name: 'token', type: principalT },
        { name: 'user', type: principalT },
      ],
      output: optionalT(numberT),
      mode: 'readonly',
    },
    'is-token-approved': {
      input: [{ name: 'token', type: principalT }],
      output: booleanT,
      mode: 'readonly',
    },
    'staking-active-at-cycle': {
      input: [
        { name: 'token', type: principalT },
        { name: 'reward-cycle', type: numberT },
      ],
      output: booleanT,
      mode: 'readonly',
    },
    'activation-block': {
      input: principalT,
      output: optionalT(numberT),
      mode: 'mapEntry',
    },
    'apower-multiplier-in-fixed': {
      input: principalT,
      output: optionalT(numberT),
      mode: 'mapEntry',
    },
    'approved-contracts': {
      input: principalT,
      output: optionalT(booleanT),
      mode: 'mapEntry',
    },
    'approved-tokens': {
      input: principalT,
      output: optionalT(booleanT),
      mode: 'mapEntry',
    },
    'coinbase-amounts': {
      input: principalT,
      output: optionalT(
        tupleT({
          'coinbase-amount-1': numberT,
          'coinbase-amount-2': numberT,
          'coinbase-amount-3': numberT,
          'coinbase-amount-4': numberT,
          'coinbase-amount-5': numberT,
        }),
      ),
      mode: 'mapEntry',
    },
    reserve: {
      input: principalT,
      output: optionalT(numberT),
      mode: 'mapEntry',
    },
    'staker-at-cycle': {
      input: tupleT({
        'reward-cycle': numberT,
        token: principalT,
        'user-id': numberT,
      }),
      output: optionalT(
        tupleT({ 'amount-staked': numberT, 'to-return': numberT }),
      ),
      mode: 'mapEntry',
    },
    'staking-stats-at-cycle': {
      input: tupleT({ 'reward-cycle': numberT, token: principalT }),
      output: optionalT(numberT),
      mode: 'mapEntry',
    },
    'user-ids': {
      input: tupleT({ token: principalT, user: principalT }),
      output: optionalT(numberT),
      mode: 'mapEntry',
    },
    users: {
      input: tupleT({ token: principalT, 'user-id': numberT }),
      output: optionalT(principalT),
      mode: 'mapEntry',
    },
    'users-nonce': {
      input: principalT,
      output: optionalT(numberT),
      mode: 'mapEntry',
    },
    'coinbase-threshold-1': { input: noneT, output: numberT, mode: 'variable' },
    'coinbase-threshold-2': { input: noneT, output: numberT, mode: 'variable' },
    'coinbase-threshold-3': { input: noneT, output: numberT, mode: 'variable' },
    'coinbase-threshold-4': { input: noneT, output: numberT, mode: 'variable' },
    'coinbase-threshold-5': { input: noneT, output: numberT, mode: 'variable' },
    'contract-owner': { input: noneT, output: principalT, mode: 'variable' },
    'reward-cycle-length': { input: noneT, output: numberT, mode: 'variable' },
    'token-halving-cycle': { input: noneT, output: numberT, mode: 'variable' },
  },
} as const);
