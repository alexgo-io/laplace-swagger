import {
  booleanT,
  defineContract,
  noneT,
  numberT,
  optionalT,
  principalT,
  responseSimpleT,
} from 'clarity-codegen';

export const dualFarmDikoHelper = defineContract({
  'dual-farm-diko-helper': {
    'add-approved-contract': {
      input: [{ name: 'new-approved-contract', type: principalT }],
      output: responseSimpleT(booleanT),
      mode: 'public',
    },
    'set-contract-owner': {
      input: [{ name: 'owner', type: principalT }],
      output: responseSimpleT(booleanT),
      mode: 'public',
    },
    'transfer-fixed': {
      input: [
        { name: 'amount', type: numberT },
        { name: 'sender', type: principalT },
        { name: 'recipient', type: principalT },
      ],
      output: responseSimpleT(booleanT),
      mode: 'public',
    },
    'get-contract-owner': {
      input: [],
      output: responseSimpleT(principalT),
      mode: 'readonly',
    },
    'approved-contracts': {
      input: principalT,
      output: optionalT(booleanT),
      mode: 'mapEntry',
    },
    'contract-owner': { input: noneT, output: principalT, mode: 'variable' },
  },
} as const);
