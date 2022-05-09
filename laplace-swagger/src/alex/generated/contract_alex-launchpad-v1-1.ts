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
  tupleT,
} from 'clarity-codegen';

export const alexLaunchpadV11 = defineContract({
  'alex-launchpad-v1-1': {
    'add-approved-operator': {
      input: [{ name: 'new-approved-operator', type: principalT }],
      output: responseSimpleT(booleanT),
      mode: 'public',
    },
    'add-to-position': {
      input: [
        { name: 'ido-id', type: numberT },
        { name: 'tickets', type: numberT },
        { name: 'ido-token', type: principalT },
      ],
      output: responseSimpleT(booleanT),
      mode: 'public',
    },
    claim: {
      input: [
        { name: 'ido-id', type: numberT },
        { name: 'input', type: listT(principalT) },
        { name: 'ido-token', type: principalT },
        { name: 'payment-token', type: principalT },
      ],
      output: responseSimpleT(booleanT),
      mode: 'public',
    },
    'claim-optimal': {
      input: [
        { name: 'ido-id', type: numberT },
        { name: 'input', type: listT(principalT) },
        { name: 'ido-token', type: principalT },
        { name: 'payment-token', type: principalT },
      ],
      output: responseSimpleT(booleanT),
      mode: 'public',
    },
    'create-pool': {
      input: [
        { name: 'ido-token', type: principalT },
        { name: 'payment-token', type: principalT },
        {
          name: 'offering',
          type: tupleT({
            'activation-threshold': numberT,
            'apower-per-ticket-in-fixed': listT(
              tupleT({
                'apower-per-ticket-in-fixed': numberT,
                'tier-threshold': numberT,
              }),
            ),
            'claim-end-height': numberT,
            'ido-owner': principalT,
            'ido-tokens-per-ticket': numberT,
            'price-per-ticket-in-fixed': numberT,
            'registration-end-height': numberT,
            'registration-max-tickets': numberT,
            'registration-start-height': numberT,
          }),
        },
      ],
      output: responseSimpleT(numberT),
      mode: 'public',
    },
    refund: {
      input: [
        { name: 'ido-id', type: numberT },
        {
          name: 'input',
          type: listT(tupleT({ amount: numberT, recipient: principalT })),
        },
        { name: 'payment-token', type: principalT },
      ],
      output: responseSimpleT(booleanT),
      mode: 'public',
    },
    'refund-optimal': {
      input: [
        { name: 'ido-id', type: numberT },
        {
          name: 'input',
          type: listT(tupleT({ amount: numberT, recipient: principalT })),
        },
        { name: 'payment-token', type: principalT },
      ],
      output: responseSimpleT(booleanT),
      mode: 'public',
    },
    register: {
      input: [
        { name: 'ido-id', type: numberT },
        { name: 'tickets', type: numberT },
        { name: 'payment-token', type: principalT },
      ],
      output: responseSimpleT(tupleT({ end: numberT, start: numberT })),
      mode: 'public',
    },
    'set-contract-owner': {
      input: [{ name: 'owner', type: principalT }],
      output: responseSimpleT(booleanT),
      mode: 'public',
    },
    'transfer-all-to-owner': {
      input: [{ name: 'token-trait', type: principalT }],
      output: responseSimpleT(booleanT),
      mode: 'public',
    },
    'buff-to-uint64': {
      input: [{ name: 'bytes', type: bufferT }],
      output: numberT,
      mode: 'readonly',
    },
    'byte-to-uint': {
      input: [{ name: 'byte', type: bufferT }],
      output: numberT,
      mode: 'readonly',
    },
    'calculate-max-step-size': {
      input: [
        { name: 'tickets-registered', type: numberT },
        { name: 'total-tickets', type: numberT },
      ],
      output: numberT,
      mode: 'readonly',
    },
    'div-down': {
      input: [
        { name: 'a', type: numberT },
        { name: 'b', type: numberT },
      ],
      output: numberT,
      mode: 'readonly',
    },
    'get-apower-required-in-fixed': {
      input: [
        { name: 'ido-id', type: numberT },
        { name: 'tickets', type: numberT },
      ],
      output: responseSimpleT(numberT),
      mode: 'readonly',
    },
    'get-contract-owner': {
      input: [],
      output: responseSimpleT(principalT),
      mode: 'readonly',
    },
    'get-ido': {
      input: [{ name: 'ido-id', type: numberT }],
      output: responseSimpleT(
        optionalT(
          tupleT({
            'activation-threshold': numberT,
            'apower-per-ticket-in-fixed': listT(
              tupleT({
                'apower-per-ticket-in-fixed': numberT,
                'tier-threshold': numberT,
              }),
            ),
            'claim-end-height': numberT,
            'ido-owner': principalT,
            'ido-token-contract': principalT,
            'ido-tokens-per-ticket': numberT,
            'payment-token-contract': principalT,
            'price-per-ticket-in-fixed': numberT,
            'registration-end-height': numberT,
            'registration-max-tickets': numberT,
            'registration-start-height': numberT,
            'total-tickets': numberT,
          }),
        ),
      ),
      mode: 'readonly',
    },
    'get-ido-id-nonce': {
      input: [],
      output: responseSimpleT(numberT),
      mode: 'readonly',
    },
    'get-initial-walk-position': {
      input: [
        { name: 'registration-end-height', type: numberT },
        { name: 'max-step-size', type: numberT },
      ],
      output: responseSimpleT(numberT),
      mode: 'readonly',
    },
    'get-last-claim-walk-position': {
      input: [
        { name: 'ido-id', type: numberT },
        { name: 'registration-end-height', type: numberT },
        { name: 'max-step-size', type: numberT },
      ],
      output: responseSimpleT(numberT),
      mode: 'readonly',
    },
    'get-offering-ticket-amounts': {
      input: [
        { name: 'ido-id', type: numberT },
        { name: 'owner', type: principalT },
      ],
      output: optionalT(numberT),
      mode: 'readonly',
    },
    'get-offering-ticket-bounds': {
      input: [
        { name: 'ido-id', type: numberT },
        { name: 'owner', type: principalT },
      ],
      output: optionalT(tupleT({ end: numberT, start: numberT })),
      mode: 'readonly',
    },
    'get-offering-walk-parameters': {
      input: [{ name: 'ido-id', type: numberT }],
      output: responseSimpleT(
        tupleT({
          'activation-threshold': numberT,
          'max-step-size': numberT,
          'total-tickets': numberT,
          'walk-position': numberT,
        }),
      ),
      mode: 'readonly',
    },
    'get-tickets-won': {
      input: [
        { name: 'ido-id', type: numberT },
        { name: 'owner', type: principalT },
      ],
      output: numberT,
      mode: 'readonly',
    },
    'get-total-tickets-registered': {
      input: [{ name: 'ido-id', type: numberT }],
      output: numberT,
      mode: 'readonly',
    },
    'get-total-tickets-won': {
      input: [{ name: 'ido-id', type: numberT }],
      output: numberT,
      mode: 'readonly',
    },
    'get-vrf-uint': {
      input: [{ name: 'height', type: numberT }],
      output: responseSimpleT(numberT),
      mode: 'readonly',
    },
    'lcg-next': {
      input: [
        { name: 'current', type: numberT },
        { name: 'max-step', type: numberT },
      ],
      output: numberT,
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
    'approved-operators': {
      input: principalT,
      output: optionalT(booleanT),
      mode: 'mapEntry',
    },
    'claim-walk-positions': {
      input: numberT,
      output: optionalT(numberT),
      mode: 'mapEntry',
    },
    'offering-ticket-amounts': {
      input: tupleT({ 'ido-id': numberT, owner: principalT }),
      output: optionalT(numberT),
      mode: 'mapEntry',
    },
    'offering-ticket-bounds': {
      input: tupleT({ 'ido-id': numberT, owner: principalT }),
      output: optionalT(tupleT({ end: numberT, start: numberT })),
      mode: 'mapEntry',
    },
    offerings: {
      input: numberT,
      output: optionalT(
        tupleT({
          'activation-threshold': numberT,
          'apower-per-ticket-in-fixed': listT(
            tupleT({
              'apower-per-ticket-in-fixed': numberT,
              'tier-threshold': numberT,
            }),
          ),
          'claim-end-height': numberT,
          'ido-owner': principalT,
          'ido-token-contract': principalT,
          'ido-tokens-per-ticket': numberT,
          'payment-token-contract': principalT,
          'price-per-ticket-in-fixed': numberT,
          'registration-end-height': numberT,
          'registration-max-tickets': numberT,
          'registration-start-height': numberT,
          'total-tickets': numberT,
        }),
      ),
      mode: 'mapEntry',
    },
    'start-indexes': {
      input: numberT,
      output: optionalT(numberT),
      mode: 'mapEntry',
    },
    'tickets-won': {
      input: tupleT({ 'ido-id': numberT, owner: principalT }),
      output: optionalT(numberT),
      mode: 'mapEntry',
    },
    'total-tickets-registered': {
      input: numberT,
      output: optionalT(numberT),
      mode: 'mapEntry',
    },
    'total-tickets-won': {
      input: numberT,
      output: optionalT(numberT),
      mode: 'mapEntry',
    },
    'contract-owner': { input: noneT, output: principalT, mode: 'variable' },
    'ido-id-nonce': { input: noneT, output: numberT, mode: 'variable' },
    'tm-amount': { input: noneT, output: numberT, mode: 'variable' },
  },
} as const);
