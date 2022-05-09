import {
  booleanT,
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

export const multisigFwpAlexUsda = defineContract({
  'multisig-fwp-alex-usda': {
    'end-proposal': {
      input: [{ name: 'proposal-id', type: numberT }],
      output: responseSimpleT(booleanT),
      mode: 'public',
    },
    propose: {
      input: [
        { name: 'start-block-height', type: numberT },
        { name: 'title', type: stringT },
        { name: 'url', type: stringT },
        { name: 'new-fee-rate-x', type: numberT },
        { name: 'new-fee-rate-y', type: numberT },
      ],
      output: responseSimpleT(numberT),
      mode: 'public',
    },
    'return-votes-to-member': {
      input: [
        { name: 'token', type: principalT },
        { name: 'proposal-id', type: numberT },
        { name: 'member', type: principalT },
      ],
      output: responseSimpleT(booleanT),
      mode: 'public',
    },
    'set-contract-owner': {
      input: [{ name: 'owner', type: principalT }],
      output: responseSimpleT(booleanT),
      mode: 'public',
    },
    'set-proposal-threshold': {
      input: [{ name: 'new-proposal-threshold', type: numberT }],
      output: responseSimpleT(booleanT),
      mode: 'public',
    },
    'set-threshold': {
      input: [{ name: 'new-threshold', type: numberT }],
      output: responseSimpleT(booleanT),
      mode: 'public',
    },
    'set-voting-period': {
      input: [{ name: 'new-voting-period', type: numberT }],
      output: responseSimpleT(booleanT),
      mode: 'public',
    },
    'vote-against': {
      input: [
        { name: 'token', type: principalT },
        { name: 'proposal-id', type: numberT },
        { name: 'amount', type: numberT },
      ],
      output: responseSimpleT(numberT),
      mode: 'public',
    },
    'vote-for': {
      input: [
        { name: 'token', type: principalT },
        { name: 'proposal-id', type: numberT },
        { name: 'amount', type: numberT },
      ],
      output: responseSimpleT(numberT),
      mode: 'public',
    },
    'get-contract-owner': {
      input: [],
      output: responseSimpleT(principalT),
      mode: 'readonly',
    },
    'get-proposal-by-id': {
      input: [{ name: 'proposal-id', type: numberT }],
      output: tupleT({
        'end-block-height': numberT,
        id: numberT,
        'is-open': booleanT,
        'new-fee-rate-x': numberT,
        'new-fee-rate-y': numberT,
        'no-votes': numberT,
        proposer: principalT,
        'start-block-height': numberT,
        title: stringT,
        url: stringT,
        'yes-votes': numberT,
      }),
      mode: 'readonly',
    },
    'get-proposal-ids': {
      input: [],
      output: responseSimpleT(listT(numberT)),
      mode: 'readonly',
    },
    'get-proposals': {
      input: [],
      output: responseSimpleT(
        listT(
          tupleT({
            'end-block-height': numberT,
            id: numberT,
            'is-open': booleanT,
            'new-fee-rate-x': numberT,
            'new-fee-rate-y': numberT,
            'no-votes': numberT,
            proposer: principalT,
            'start-block-height': numberT,
            title: stringT,
            url: stringT,
            'yes-votes': numberT,
          }),
        ),
      ),
      mode: 'readonly',
    },
    'get-tokens-by-member-by-id': {
      input: [
        { name: 'proposal-id', type: numberT },
        { name: 'member', type: principalT },
        { name: 'token', type: principalT },
      ],
      output: tupleT({ amount: numberT }),
      mode: 'readonly',
    },
    'get-votes-by-member-by-id': {
      input: [
        { name: 'proposal-id', type: numberT },
        { name: 'member', type: principalT },
      ],
      output: tupleT({ 'vote-count': numberT }),
      mode: 'readonly',
    },
    'is-token-accepted': {
      input: [{ name: 'token', type: principalT }],
      output: booleanT,
      mode: 'readonly',
    },
    proposals: {
      input: tupleT({ id: numberT }),
      output: optionalT(
        tupleT({
          'end-block-height': numberT,
          id: numberT,
          'is-open': booleanT,
          'new-fee-rate-x': numberT,
          'new-fee-rate-y': numberT,
          'no-votes': numberT,
          proposer: principalT,
          'start-block-height': numberT,
          title: stringT,
          url: stringT,
          'yes-votes': numberT,
        }),
      ),
      mode: 'mapEntry',
    },
    'tokens-by-member': {
      input: tupleT({
        member: principalT,
        'proposal-id': numberT,
        token: principalT,
      }),
      output: optionalT(tupleT({ amount: numberT })),
      mode: 'mapEntry',
    },
    'votes-by-member': {
      input: tupleT({ member: principalT, 'proposal-id': numberT }),
      output: optionalT(tupleT({ 'vote-count': numberT })),
      mode: 'mapEntry',
    },
    'contract-owner': { input: noneT, output: principalT, mode: 'variable' },
    'proposal-count': { input: noneT, output: numberT, mode: 'variable' },
    'proposal-ids': { input: noneT, output: listT(numberT), mode: 'variable' },
    'proposal-threshold': { input: noneT, output: numberT, mode: 'variable' },
    threshold: { input: noneT, output: numberT, mode: 'variable' },
    'threshold-percentage': { input: noneT, output: numberT, mode: 'variable' },
    'total-supply-of-token': {
      input: noneT,
      output: numberT,
      mode: 'variable',
    },
    'voting-period': { input: noneT, output: numberT, mode: 'variable' },
  },
} as const);
