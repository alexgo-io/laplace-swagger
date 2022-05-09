import {
  booleanT,
  defineContract,
  listT,
  noneT,
  numberT,
  optionalT,
  principalT,
  responseSimpleT,
  tupleT,
} from 'clarity-codegen';

export const fixedWeightPoolV101 = defineContract({
  'fixed-weight-pool-v1-01': {
    'add-to-position': {
      input: [
        { name: 'token-x-trait', type: principalT },
        { name: 'token-y-trait', type: principalT },
        { name: 'weight-x', type: numberT },
        { name: 'weight-y', type: numberT },
        { name: 'pool-token-trait', type: principalT },
        { name: 'dx', type: numberT },
        { name: 'max-dy', type: optionalT(numberT) },
      ],
      output: responseSimpleT(
        tupleT({ dx: numberT, dy: numberT, supply: numberT }),
      ),
      mode: 'public',
    },
    'create-pool': {
      input: [
        { name: 'token-x-trait', type: principalT },
        { name: 'token-y-trait', type: principalT },
        { name: 'weight-x', type: numberT },
        { name: 'weight-y', type: numberT },
        { name: 'pool-token-trait', type: principalT },
        { name: 'multisig-vote', type: principalT },
        { name: 'dx', type: numberT },
        { name: 'dy', type: numberT },
      ],
      output: responseSimpleT(booleanT),
      mode: 'public',
    },
    'reduce-position': {
      input: [
        { name: 'token-x-trait', type: principalT },
        { name: 'token-y-trait', type: principalT },
        { name: 'weight-x', type: numberT },
        { name: 'weight-y', type: numberT },
        { name: 'pool-token-trait', type: principalT },
        { name: 'percent', type: numberT },
      ],
      output: responseSimpleT(tupleT({ dx: numberT, dy: numberT })),
      mode: 'public',
    },
    'set-contract-owner': {
      input: [{ name: 'owner', type: principalT }],
      output: responseSimpleT(booleanT),
      mode: 'public',
    },
    'set-fee-rate-x': {
      input: [
        { name: 'token-x', type: principalT },
        { name: 'token-y', type: principalT },
        { name: 'weight-x', type: numberT },
        { name: 'weight-y', type: numberT },
        { name: 'fee-rate-x', type: numberT },
      ],
      output: responseSimpleT(booleanT),
      mode: 'public',
    },
    'set-fee-rate-y': {
      input: [
        { name: 'token-x', type: principalT },
        { name: 'token-y', type: principalT },
        { name: 'weight-x', type: numberT },
        { name: 'weight-y', type: numberT },
        { name: 'fee-rate-y', type: numberT },
      ],
      output: responseSimpleT(booleanT),
      mode: 'public',
    },
    'set-fee-rebate': {
      input: [
        { name: 'token-x', type: principalT },
        { name: 'token-y', type: principalT },
        { name: 'weight-x', type: numberT },
        { name: 'weight-y', type: numberT },
        { name: 'fee-rebate', type: numberT },
      ],
      output: responseSimpleT(booleanT),
      mode: 'public',
    },
    'set-fee-to-address': {
      input: [
        { name: 'token-x', type: principalT },
        { name: 'token-y', type: principalT },
        { name: 'weight-x', type: numberT },
        { name: 'weight-y', type: numberT },
        { name: 'fee-to-address', type: principalT },
      ],
      output: responseSimpleT(booleanT),
      mode: 'public',
    },
    'set-oracle-average': {
      input: [
        { name: 'token-x', type: principalT },
        { name: 'token-y', type: principalT },
        { name: 'weight-x', type: numberT },
        { name: 'weight-y', type: numberT },
        { name: 'new-oracle-average', type: numberT },
      ],
      output: responseSimpleT(booleanT),
      mode: 'public',
    },
    'set-oracle-enabled': {
      input: [
        { name: 'token-x', type: principalT },
        { name: 'token-y', type: principalT },
        { name: 'weight-x', type: numberT },
        { name: 'weight-y', type: numberT },
      ],
      output: responseSimpleT(booleanT),
      mode: 'public',
    },
    'swap-helper': {
      input: [
        { name: 'token-x-trait', type: principalT },
        { name: 'token-y-trait', type: principalT },
        { name: 'weight-x', type: numberT },
        { name: 'weight-y', type: numberT },
        { name: 'dx', type: numberT },
        { name: 'min-dy', type: optionalT(numberT) },
      ],
      output: responseSimpleT(numberT),
      mode: 'public',
    },
    'swap-wstx-for-y': {
      input: [
        { name: 'token-y-trait', type: principalT },
        { name: 'weight-y', type: numberT },
        { name: 'dx', type: numberT },
        { name: 'min-dy', type: optionalT(numberT) },
      ],
      output: responseSimpleT(tupleT({ dx: numberT, dy: numberT })),
      mode: 'public',
    },
    'swap-x-for-y': {
      input: [
        { name: 'token-x-trait', type: principalT },
        { name: 'token-y-trait', type: principalT },
        { name: 'weight-x', type: numberT },
        { name: 'weight-y', type: numberT },
        { name: 'dx', type: numberT },
        { name: 'min-dy', type: optionalT(numberT) },
      ],
      output: responseSimpleT(tupleT({ dx: numberT, dy: numberT })),
      mode: 'public',
    },
    'swap-y-for-wstx': {
      input: [
        { name: 'token-y-trait', type: principalT },
        { name: 'weight-y', type: numberT },
        { name: 'dy', type: numberT },
        { name: 'min-dx', type: optionalT(numberT) },
      ],
      output: responseSimpleT(tupleT({ dx: numberT, dy: numberT })),
      mode: 'public',
    },
    'swap-y-for-x': {
      input: [
        { name: 'token-x-trait', type: principalT },
        { name: 'token-y-trait', type: principalT },
        { name: 'weight-x', type: numberT },
        { name: 'weight-y', type: numberT },
        { name: 'dy', type: numberT },
        { name: 'min-dx', type: optionalT(numberT) },
      ],
      output: responseSimpleT(tupleT({ dx: numberT, dy: numberT })),
      mode: 'public',
    },
    'div-down': {
      input: [
        { name: 'a', type: numberT },
        { name: 'b', type: numberT },
      ],
      output: numberT,
      mode: 'readonly',
    },
    'div-up': {
      input: [
        { name: 'a', type: numberT },
        { name: 'b', type: numberT },
      ],
      output: numberT,
      mode: 'readonly',
    },
    'exp-fixed': {
      input: [{ name: 'x', type: numberT }],
      output: responseSimpleT(numberT),
      mode: 'readonly',
    },
    'get-balances': {
      input: [
        { name: 'token-x', type: principalT },
        { name: 'token-y', type: principalT },
        { name: 'weight-x', type: numberT },
        { name: 'weight-y', type: numberT },
      ],
      output: responseSimpleT(
        tupleT({ 'balance-x': numberT, 'balance-y': numberT }),
      ),
      mode: 'readonly',
    },
    'get-contract-owner': {
      input: [],
      output: responseSimpleT(principalT),
      mode: 'readonly',
    },
    'get-exp-bound': {
      input: [],
      output: responseSimpleT(numberT),
      mode: 'readonly',
    },
    'get-fee-rate-x': {
      input: [
        { name: 'token-x', type: principalT },
        { name: 'token-y', type: principalT },
        { name: 'weight-x', type: numberT },
        { name: 'weight-y', type: numberT },
      ],
      output: responseSimpleT(numberT),
      mode: 'readonly',
    },
    'get-fee-rate-y': {
      input: [
        { name: 'token-x', type: principalT },
        { name: 'token-y', type: principalT },
        { name: 'weight-x', type: numberT },
        { name: 'weight-y', type: numberT },
      ],
      output: responseSimpleT(numberT),
      mode: 'readonly',
    },
    'get-fee-rebate': {
      input: [
        { name: 'token-x', type: principalT },
        { name: 'token-y', type: principalT },
        { name: 'weight-x', type: numberT },
        { name: 'weight-y', type: numberT },
      ],
      output: responseSimpleT(numberT),
      mode: 'readonly',
    },
    'get-fee-to-address': {
      input: [
        { name: 'token-x', type: principalT },
        { name: 'token-y', type: principalT },
        { name: 'weight-x', type: numberT },
        { name: 'weight-y', type: numberT },
      ],
      output: responseSimpleT(principalT),
      mode: 'readonly',
    },
    'get-helper': {
      input: [
        { name: 'token-x', type: principalT },
        { name: 'token-y', type: principalT },
        { name: 'weight-x', type: numberT },
        { name: 'weight-y', type: numberT },
        { name: 'dx', type: numberT },
      ],
      output: responseSimpleT(numberT),
      mode: 'readonly',
    },
    'get-oracle-average': {
      input: [
        { name: 'token-x', type: principalT },
        { name: 'token-y', type: principalT },
        { name: 'weight-x', type: numberT },
        { name: 'weight-y', type: numberT },
      ],
      output: responseSimpleT(numberT),
      mode: 'readonly',
    },
    'get-oracle-enabled': {
      input: [
        { name: 'token-x', type: principalT },
        { name: 'token-y', type: principalT },
        { name: 'weight-x', type: numberT },
        { name: 'weight-y', type: numberT },
      ],
      output: responseSimpleT(booleanT),
      mode: 'readonly',
    },
    'get-oracle-instant': {
      input: [
        { name: 'token-x', type: principalT },
        { name: 'token-y', type: principalT },
        { name: 'weight-x', type: numberT },
        { name: 'weight-y', type: numberT },
      ],
      output: responseSimpleT(numberT),
      mode: 'readonly',
    },
    'get-oracle-resilient': {
      input: [
        { name: 'token-x', type: principalT },
        { name: 'token-y', type: principalT },
        { name: 'weight-x', type: numberT },
        { name: 'weight-y', type: numberT },
      ],
      output: responseSimpleT(numberT),
      mode: 'readonly',
    },
    'get-pool-contracts': {
      input: [{ name: 'pool-id', type: numberT }],
      output: responseSimpleT(
        tupleT({
          'token-x': principalT,
          'token-y': principalT,
          'weight-x': numberT,
          'weight-y': numberT,
        }),
      ),
      mode: 'readonly',
    },
    'get-pool-count': { input: [], output: numberT, mode: 'readonly' },
    'get-pool-details': {
      input: [
        { name: 'token-x', type: principalT },
        { name: 'token-y', type: principalT },
        { name: 'weight-x', type: numberT },
        { name: 'weight-y', type: numberT },
      ],
      output: responseSimpleT(
        tupleT({
          'balance-x': numberT,
          'balance-y': numberT,
          'fee-rate-x': numberT,
          'fee-rate-y': numberT,
          'fee-rebate': numberT,
          'fee-to-address': principalT,
          'oracle-average': numberT,
          'oracle-enabled': booleanT,
          'oracle-resilient': numberT,
          'pool-token': principalT,
          'total-supply': numberT,
        }),
      ),
      mode: 'readonly',
    },
    'get-pool-exists': {
      input: [
        { name: 'token-x', type: principalT },
        { name: 'token-y', type: principalT },
        { name: 'weight-x', type: numberT },
        { name: 'weight-y', type: numberT },
      ],
      output: optionalT(
        tupleT({
          'balance-x': numberT,
          'balance-y': numberT,
          'fee-rate-x': numberT,
          'fee-rate-y': numberT,
          'fee-rebate': numberT,
          'fee-to-address': principalT,
          'oracle-average': numberT,
          'oracle-enabled': booleanT,
          'oracle-resilient': numberT,
          'pool-token': principalT,
          'total-supply': numberT,
        }),
      ),
      mode: 'readonly',
    },
    'get-pools': {
      input: [],
      output: responseSimpleT(
        listT(
          responseSimpleT(
            tupleT({
              'token-x': principalT,
              'token-y': principalT,
              'weight-x': numberT,
              'weight-y': numberT,
            }),
          ),
        ),
      ),
      mode: 'readonly',
    },
    'get-pools-by-ids': {
      input: [{ name: 'pool-ids', type: listT(numberT) }],
      output: responseSimpleT(
        listT(
          responseSimpleT(
            tupleT({
              'token-x': principalT,
              'token-y': principalT,
              'weight-x': numberT,
              'weight-y': numberT,
            }),
          ),
        ),
      ),
      mode: 'readonly',
    },
    'get-position-given-burn': {
      input: [
        { name: 'token-x', type: principalT },
        { name: 'token-y', type: principalT },
        { name: 'weight-x', type: numberT },
        { name: 'weight-y', type: numberT },
        { name: 'token', type: numberT },
      ],
      output: responseSimpleT(tupleT({ dx: numberT, dy: numberT })),
      mode: 'readonly',
    },
    'get-position-given-mint': {
      input: [
        { name: 'token-x', type: principalT },
        { name: 'token-y', type: principalT },
        { name: 'weight-x', type: numberT },
        { name: 'weight-y', type: numberT },
        { name: 'token', type: numberT },
      ],
      output: responseSimpleT(tupleT({ dx: numberT, dy: numberT })),
      mode: 'readonly',
    },
    'get-token-given-position': {
      input: [
        { name: 'token-x', type: principalT },
        { name: 'token-y', type: principalT },
        { name: 'weight-x', type: numberT },
        { name: 'weight-y', type: numberT },
        { name: 'dx', type: numberT },
        { name: 'max-dy', type: optionalT(numberT) },
      ],
      output: responseSimpleT(tupleT({ dy: numberT, token: numberT })),
      mode: 'readonly',
    },
    'get-wstx-given-y': {
      input: [
        { name: 'token-y', type: principalT },
        { name: 'weight-y', type: numberT },
        { name: 'dy', type: numberT },
      ],
      output: responseSimpleT(numberT),
      mode: 'readonly',
    },
    'get-wstx-in-given-y-out': {
      input: [
        { name: 'token-y', type: principalT },
        { name: 'weight-y', type: numberT },
        { name: 'dy', type: numberT },
      ],
      output: responseSimpleT(numberT),
      mode: 'readonly',
    },
    'get-x-given-price': {
      input: [
        { name: 'token-x', type: principalT },
        { name: 'token-y', type: principalT },
        { name: 'weight-x', type: numberT },
        { name: 'weight-y', type: numberT },
        { name: 'price', type: numberT },
      ],
      output: responseSimpleT(numberT),
      mode: 'readonly',
    },
    'get-x-given-y': {
      input: [
        { name: 'token-x', type: principalT },
        { name: 'token-y', type: principalT },
        { name: 'weight-x', type: numberT },
        { name: 'weight-y', type: numberT },
        { name: 'dy', type: numberT },
      ],
      output: responseSimpleT(numberT),
      mode: 'readonly',
    },
    'get-x-in-given-y-out': {
      input: [
        { name: 'token-x', type: principalT },
        { name: 'token-y', type: principalT },
        { name: 'weight-x', type: numberT },
        { name: 'weight-y', type: numberT },
        { name: 'dy', type: numberT },
      ],
      output: responseSimpleT(numberT),
      mode: 'readonly',
    },
    'get-y-given-price': {
      input: [
        { name: 'token-x', type: principalT },
        { name: 'token-y', type: principalT },
        { name: 'weight-x', type: numberT },
        { name: 'weight-y', type: numberT },
        { name: 'price', type: numberT },
      ],
      output: responseSimpleT(numberT),
      mode: 'readonly',
    },
    'get-y-given-wstx': {
      input: [
        { name: 'token-y', type: principalT },
        { name: 'weight-y', type: numberT },
        { name: 'dx', type: numberT },
      ],
      output: responseSimpleT(numberT),
      mode: 'readonly',
    },
    'get-y-given-x': {
      input: [
        { name: 'token-x', type: principalT },
        { name: 'token-y', type: principalT },
        { name: 'weight-x', type: numberT },
        { name: 'weight-y', type: numberT },
        { name: 'dx', type: numberT },
      ],
      output: responseSimpleT(numberT),
      mode: 'readonly',
    },
    'get-y-in-given-wstx-out': {
      input: [
        { name: 'token-y', type: principalT },
        { name: 'weight-y', type: numberT },
        { name: 'dx', type: numberT },
      ],
      output: responseSimpleT(numberT),
      mode: 'readonly',
    },
    'get-y-in-given-x-out': {
      input: [
        { name: 'token-x', type: principalT },
        { name: 'token-y', type: principalT },
        { name: 'weight-x', type: numberT },
        { name: 'weight-y', type: numberT },
        { name: 'dx', type: numberT },
      ],
      output: responseSimpleT(numberT),
      mode: 'readonly',
    },
    'ln-fixed': {
      input: [{ name: 'a', type: numberT }],
      output: responseSimpleT(numberT),
      mode: 'readonly',
    },
    'mul-down': {
      input: [
        { name: 'a', type: numberT },
        { name: 'b', type: numberT },
      ],
      output: numberT,
      mode: 'readonly',
    },
    'mul-up': {
      input: [
        { name: 'a', type: numberT },
        { name: 'b', type: numberT },
      ],
      output: numberT,
      mode: 'readonly',
    },
    'pow-down': {
      input: [
        { name: 'a', type: numberT },
        { name: 'b', type: numberT },
      ],
      output: numberT,
      mode: 'readonly',
    },
    'pow-fixed': {
      input: [
        { name: 'x', type: numberT },
        { name: 'y', type: numberT },
      ],
      output: responseSimpleT(numberT),
      mode: 'readonly',
    },
    'pow-up': {
      input: [
        { name: 'a', type: numberT },
        { name: 'b', type: numberT },
      ],
      output: numberT,
      mode: 'readonly',
    },
    'pools-data-map': {
      input: tupleT({
        'token-x': principalT,
        'token-y': principalT,
        'weight-x': numberT,
        'weight-y': numberT,
      }),
      output: optionalT(
        tupleT({
          'balance-x': numberT,
          'balance-y': numberT,
          'fee-rate-x': numberT,
          'fee-rate-y': numberT,
          'fee-rebate': numberT,
          'fee-to-address': principalT,
          'oracle-average': numberT,
          'oracle-enabled': booleanT,
          'oracle-resilient': numberT,
          'pool-token': principalT,
          'total-supply': numberT,
        }),
      ),
      mode: 'mapEntry',
    },
    'pools-map': {
      input: tupleT({ 'pool-id': numberT }),
      output: optionalT(
        tupleT({
          'token-x': principalT,
          'token-y': principalT,
          'weight-x': numberT,
          'weight-y': numberT,
        }),
      ),
      mode: 'mapEntry',
    },
    'contract-owner': { input: noneT, output: principalT, mode: 'variable' },
    'pool-count': { input: noneT, output: numberT, mode: 'variable' },
    'pools-list': { input: noneT, output: listT(numberT), mode: 'variable' },
  },
} as const);
