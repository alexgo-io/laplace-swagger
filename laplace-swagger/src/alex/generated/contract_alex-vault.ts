import {
  booleanT,
  bufferT,
  defineContract,
  noneT,
  numberT,
  optionalT,
  principalT,
  responseSimpleT,
} from 'clarity-codegen';

export const alexVault = defineContract({
  'alex-vault': {
    'add-approved-contract': {
      input: [{ name: 'new-approved-contract', type: principalT }],
      output: responseSimpleT(booleanT),
      mode: 'public',
    },
    'add-approved-flash-loan-user': {
      input: [{ name: 'new-approved-flash-loan-user', type: principalT }],
      output: responseSimpleT(booleanT),
      mode: 'public',
    },
    'add-approved-token': {
      input: [{ name: 'new-approved-token', type: principalT }],
      output: responseSimpleT(booleanT),
      mode: 'public',
    },
    'flash-loan': {
      input: [
        { name: 'flash-loan-user', type: principalT },
        { name: 'token', type: principalT },
        { name: 'amount', type: numberT },
        { name: 'memo', type: optionalT(bufferT) },
      ],
      output: responseSimpleT(numberT),
      mode: 'public',
    },
    'get-balance': {
      input: [{ name: 'token', type: principalT }],
      output: responseSimpleT(numberT),
      mode: 'public',
    },
    'set-contract-owner': {
      input: [{ name: 'owner', type: principalT }],
      output: responseSimpleT(booleanT),
      mode: 'public',
    },
    'set-flash-loan-fee-rate': {
      input: [{ name: 'fee', type: numberT }],
      output: responseSimpleT(booleanT),
      mode: 'public',
    },
    'transfer-ft': {
      input: [
        { name: 'token', type: principalT },
        { name: 'amount', type: numberT },
        { name: 'recipient', type: principalT },
      ],
      output: responseSimpleT(booleanT),
      mode: 'public',
    },
    'transfer-ft-two': {
      input: [
        { name: 'token-x-trait', type: principalT },
        { name: 'dx', type: numberT },
        { name: 'token-y-trait', type: principalT },
        { name: 'dy', type: numberT },
        { name: 'recipient', type: principalT },
      ],
      output: responseSimpleT(booleanT),
      mode: 'public',
    },
    'transfer-sft': {
      input: [
        { name: 'token', type: principalT },
        { name: 'token-id', type: numberT },
        { name: 'amount', type: numberT },
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
    'get-flash-loan-fee-rate': {
      input: [],
      output: responseSimpleT(numberT),
      mode: 'readonly',
    },
    'approved-contracts': {
      input: principalT,
      output: optionalT(booleanT),
      mode: 'mapEntry',
    },
    'approved-flash-loan-users': {
      input: principalT,
      output: optionalT(booleanT),
      mode: 'mapEntry',
    },
    'approved-tokens': {
      input: principalT,
      output: optionalT(booleanT),
      mode: 'mapEntry',
    },
    'contract-owner': { input: noneT, output: principalT, mode: 'variable' },
    'flash-loan-fee-rate': { input: noneT, output: numberT, mode: 'variable' },
  },
} as const);
