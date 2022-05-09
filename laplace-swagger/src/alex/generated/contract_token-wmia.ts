import {
  booleanT,
  bufferT,
  defineContract,
  listT,
  noneT,
  numberT,
  optionalT,
  principalT,
  responseSimpleT,
  stringT,
  tupleT,
} from 'clarity-codegen';

export const tokenWmia = defineContract({
  'token-wmia': {
    burn: {
      input: [
        { name: 'amount', type: numberT },
        { name: 'sender', type: principalT },
      ],
      output: responseSimpleT(noneT),
      mode: 'public',
    },
    'burn-fixed': {
      input: [
        { name: 'amount', type: numberT },
        { name: 'sender', type: principalT },
      ],
      output: responseSimpleT(noneT),
      mode: 'public',
    },
    mint: {
      input: [
        { name: 'amount', type: numberT },
        { name: 'recipient', type: principalT },
      ],
      output: responseSimpleT(noneT),
      mode: 'public',
    },
    'mint-fixed': {
      input: [
        { name: 'amount', type: numberT },
        { name: 'recipient', type: principalT },
      ],
      output: responseSimpleT(noneT),
      mode: 'public',
    },
    'send-many': {
      input: [
        {
          name: 'recipients',
          type: listT(tupleT({ amount: numberT, to: principalT })),
        },
      ],
      output: responseSimpleT(booleanT),
      mode: 'public',
    },
    'set-contract-owner': {
      input: [{ name: 'owner', type: principalT }],
      output: responseSimpleT(booleanT),
      mode: 'public',
    },
    'set-decimals': {
      input: [{ name: 'new-decimals', type: numberT }],
      output: responseSimpleT(booleanT),
      mode: 'public',
    },
    'set-name': {
      input: [{ name: 'new-name', type: stringT }],
      output: responseSimpleT(booleanT),
      mode: 'public',
    },
    'set-symbol': {
      input: [{ name: 'new-symbol', type: stringT }],
      output: responseSimpleT(booleanT),
      mode: 'public',
    },
    'set-token-uri': {
      input: [{ name: 'new-uri', type: optionalT(stringT) }],
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
      output: responseSimpleT(noneT),
      mode: 'readonly',
    },
    'get-total-supply-fixed': {
      input: [],
      output: responseSimpleT(noneT),
      mode: 'readonly',
    },
    'contract-owner': { input: noneT, output: principalT, mode: 'variable' },
    'token-decimals': { input: noneT, output: numberT, mode: 'variable' },
    'token-name': { input: noneT, output: stringT, mode: 'variable' },
    'token-symbol': { input: noneT, output: stringT, mode: 'variable' },
    'token-uri': { input: noneT, output: optionalT(stringT), mode: 'variable' },
  },
} as const);
