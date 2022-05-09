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

export const autoAlex = defineContract({
  'auto-alex': {
    'add-approved-contract': {
      input: [{ name: 'new-approved-contract', type: principalT }],
      output: responseSimpleT(booleanT),
      mode: 'public',
    },
    'add-to-position': {
      input: [{ name: 'dx', type: numberT }],
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
    'claim-and-mint': {
      input: [{ name: 'reward-cycles', type: listT(numberT) }],
      output: responseSimpleT(
        listT(
          responseSimpleT(
            tupleT({ 'entitled-token': numberT, 'to-return': numberT }),
          ),
        ),
      ),
      mode: 'public',
    },
    'claim-and-stake': {
      input: [{ name: 'reward-cycle', type: numberT }],
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
    'mint-fixed-many': {
      input: [
        {
          name: 'recipients',
          type: listT(tupleT({ amount: numberT, recipient: principalT })),
        },
      ],
      output: responseSimpleT(listT(responseSimpleT(booleanT))),
      mode: 'public',
    },
    'reduce-position': {
      input: [{ name: 'percent', type: numberT }],
      output: responseSimpleT(numberT),
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
    'set-bounty-in-fixed': {
      input: [{ name: 'new-bounty-in-fixed', type: numberT }],
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
    'set-end-cycle': {
      input: [{ name: 'new-end-cycle', type: numberT }],
      output: responseSimpleT(booleanT),
      mode: 'public',
    },
    'set-name': {
      input: [{ name: 'new-name', type: stringT }],
      output: responseSimpleT(booleanT),
      mode: 'public',
    },
    'set-start-block': {
      input: [{ name: 'new-start-block', type: numberT }],
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
      input: [{ name: 'who', type: principalT }],
      output: responseSimpleT(numberT),
      mode: 'readonly',
    },
    'get-balance-fixed': {
      input: [{ name: 'account', type: principalT }],
      output: responseSimpleT(numberT),
      mode: 'readonly',
    },
    'get-bounty-in-fixed': {
      input: [],
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
    'get-end-cycle': { input: [], output: numberT, mode: 'readonly' },
    'get-intrinsic': {
      input: [],
      output: responseSimpleT(numberT),
      mode: 'readonly',
    },
    'get-name': {
      input: [],
      output: responseSimpleT(stringT),
      mode: 'readonly',
    },
    'get-next-base': {
      input: [],
      output: responseSimpleT(numberT),
      mode: 'readonly',
    },
    'get-start-block': { input: [], output: numberT, mode: 'readonly' },
    'get-symbol': {
      input: [],
      output: responseSimpleT(stringT),
      mode: 'readonly',
    },
    'get-token-given-position': {
      input: [{ name: 'dx', type: numberT }],
      output: responseSimpleT(numberT),
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
    'is-cycle-bountiable': {
      input: [{ name: 'reward-cycle', type: numberT }],
      output: booleanT,
      mode: 'readonly',
    },
    'approved-contracts': {
      input: principalT,
      output: optionalT(booleanT),
      mode: 'mapEntry',
    },
    'bounty-in-fixed': { input: noneT, output: numberT, mode: 'variable' },
    'contract-owner': { input: noneT, output: principalT, mode: 'variable' },
    'end-cycle': { input: noneT, output: numberT, mode: 'variable' },
    'start-block': { input: noneT, output: numberT, mode: 'variable' },
    'token-decimals': { input: noneT, output: numberT, mode: 'variable' },
    'token-name': { input: noneT, output: stringT, mode: 'variable' },
    'token-symbol': { input: noneT, output: stringT, mode: 'variable' },
    'token-uri': { input: noneT, output: optionalT(stringT), mode: 'variable' },
    'total-supply': { input: noneT, output: numberT, mode: 'variable' },
  },
} as const);
