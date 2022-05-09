import {
  booleanT,
  bufferT,
  defineContract,
  noneT,
  numberT,
  optionalT,
  principalT,
  responseSimpleT,
  stringT,
} from 'clarity-codegen';

export const tokenNycc = defineContract({
  'token-nycc': {
    'add-approved-contract': {
      input: [{ name: 'new-approved-contract', type: principalT }],
      output: responseSimpleT(booleanT),
      mode: 'public',
    },
    burn: {
      input: [
        { name: 'amount', type: numberT },
        { name: 'sender', type: principalT },
      ],
      output: responseSimpleT(booleanT),
      mode: 'public',
    },
    'burn-fixed': {
      input: [
        { name: 'amount', type: numberT },
        { name: 'sender', type: principalT },
      ],
      output: responseSimpleT(booleanT),
      mode: 'public',
    },
    mint: {
      input: [
        { name: 'amount', type: numberT },
        { name: 'recipient', type: principalT },
      ],
      output: responseSimpleT(booleanT),
      mode: 'public',
    },
    'mint-fixed': {
      input: [
        { name: 'amount', type: numberT },
        { name: 'recipient', type: principalT },
      ],
      output: responseSimpleT(booleanT),
      mode: 'public',
    },
    'set-approved-contract': {
      input: [
        { name: 'owner', type: principalT },
        { name: 'approved', type: booleanT },
      ],
      output: responseSimpleT(booleanT),
      mode: 'public',
    },
    'set-contract-owner': {
      input: [{ name: 'owner', type: principalT }],
      output: responseSimpleT(booleanT),
      mode: 'public',
    },
    'set-token-uri': {
      input: [{ name: 'value', type: stringT }],
      output: responseSimpleT(booleanT),
      mode: 'public',
    },
    transfer: {
      input: [
        { name: 'amount', type: numberT },
        { name: 'sender', type: principalT },
        { name: 'recipient', type: principalT },
        { name: 'memo', type: optionalT(bufferT) },
      ],
      output: responseSimpleT(booleanT),
      mode: 'public',
    },
    'transfer-fixed': {
      input: [
        { name: 'amount', type: numberT },
        { name: 'sender', type: principalT },
        { name: 'recipient', type: principalT },
        { name: 'memo', type: optionalT(bufferT) },
      ],
      output: responseSimpleT(booleanT),
      mode: 'public',
    },
    'fixed-to-decimals': {
      input: [{ name: 'amount', type: numberT }],
      output: numberT,
      mode: 'readonly',
    },
    'get-balance': {
      input: [{ name: 'account', type: principalT }],
      output: responseSimpleT(numberT),
      mode: 'readonly',
    },
    'get-balance-fixed': {
      input: [{ name: 'account', type: principalT }],
      output: responseSimpleT(numberT),
      mode: 'readonly',
    },
    'get-contract-owner': {
      input: [],
      output: responseSimpleT(principalT),
      mode: 'readonly',
    },
    'get-decimals': {
      input: [],
      output: responseSimpleT(numberT),
      mode: 'readonly',
    },
    'get-name': {
      input: [],
      output: responseSimpleT(stringT),
      mode: 'readonly',
    },
    'get-symbol': {
      input: [],
      output: responseSimpleT(stringT),
      mode: 'readonly',
    },
    'get-token-uri': {
      input: [],
      output: responseSimpleT(optionalT(stringT)),
      mode: 'readonly',
    },
    'get-total-supply': {
      input: [],
      output: responseSimpleT(numberT),
      mode: 'readonly',
    },
    'get-total-supply-fixed': {
      input: [],
      output: responseSimpleT(numberT),
      mode: 'readonly',
    },
    'approved-contracts': {
      input: principalT,
      output: optionalT(booleanT),
      mode: 'mapEntry',
    },
    'contract-owner': { input: noneT, output: principalT, mode: 'variable' },
    'token-uri': { input: noneT, output: stringT, mode: 'variable' },
  },
} as const);
