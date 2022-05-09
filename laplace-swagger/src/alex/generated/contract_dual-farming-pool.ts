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

export const dualFarmingPool = defineContract({
  'dual-farming-pool': {
    'add-token': {
      input: [
        { name: 'token', type: principalT },
        { name: 'dual-token', type: principalT },
        { name: 'underlying-token', type: principalT },
      ],
      output: responseSimpleT(booleanT),
      mode: 'public',
    },
    'claim-staking-reward': {
      input: [
        { name: 'token', type: principalT },
        { name: 'dual-token', type: principalT },
        { name: 'reward-cycles', type: listT(numberT) },
      ],
      output: responseSimpleT(
        listT(
          responseSimpleT(
            tupleT({
              'entitled-dual': numberT,
              'entitled-token': numberT,
              'to-return': numberT,
            }),
          ),
        ),
      ),
      mode: 'public',
    },
    'set-contract-owner': {
      input: [{ name: 'owner', type: principalT }],
      output: responseSimpleT(booleanT),
      mode: 'public',
    },
    'set-multiplier-in-fixed': {
      input: [
        { name: 'token', type: principalT },
        { name: 'new-multiplier-in-fixed', type: numberT },
      ],
      output: responseSimpleT(booleanT),
      mode: 'public',
    },
    'get-contract-owner': {
      input: [],
      output: responseSimpleT(principalT),
      mode: 'readonly',
    },
    'get-dual-token-underlying': {
      input: [{ name: 'token', type: principalT }],
      output: responseSimpleT(principalT),
      mode: 'readonly',
    },
    'get-multiplier-in-fixed-or-default': {
      input: [{ name: 'token', type: principalT }],
      output: numberT,
      mode: 'readonly',
    },
    'approved-pair': {
      input: principalT,
      output: optionalT(principalT),
      mode: 'mapEntry',
    },
    'dual-underlying': {
      input: principalT,
      output: optionalT(principalT),
      mode: 'mapEntry',
    },
    'multiplier-in-fixed': {
      input: principalT,
      output: optionalT(numberT),
      mode: 'mapEntry',
    },
    'contract-owner': { input: noneT, output: principalT, mode: 'variable' },
  },
} as const);
