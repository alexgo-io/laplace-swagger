import {
  defineContract,
  listT,
  numberT,
  optionalT,
  principalT,
  responseSimpleT,
} from 'clarity-codegen';

export const swapHelperV101 = defineContract({
  'swap-helper-v1-01': {
    'swap-helper': {
      input: [
        { name: 'token-x-trait', type: principalT },
        { name: 'token-y-trait', type: principalT },
        { name: 'dx', type: numberT },
        { name: 'min-dy', type: optionalT(numberT) },
      ],
      output: responseSimpleT(numberT),
      mode: 'public',
    },
    'fee-helper': {
      input: [
        { name: 'token-x', type: principalT },
        { name: 'token-y', type: principalT },
      ],
      output: responseSimpleT(numberT),
      mode: 'readonly',
    },
    'get-given-helper': {
      input: [
        { name: 'token-x', type: principalT },
        { name: 'token-y', type: principalT },
        { name: 'dy', type: numberT },
      ],
      output: responseSimpleT(numberT),
      mode: 'readonly',
    },
    'get-helper': {
      input: [
        { name: 'token-x', type: principalT },
        { name: 'token-y', type: principalT },
        { name: 'dx', type: numberT },
      ],
      output: responseSimpleT(numberT),
      mode: 'readonly',
    },
    'oracle-instant-helper': {
      input: [
        { name: 'token-x', type: principalT },
        { name: 'token-y', type: principalT },
      ],
      output: responseSimpleT(numberT),
      mode: 'readonly',
    },
    'oracle-resilient-helper': {
      input: [
        { name: 'token-x', type: principalT },
        { name: 'token-y', type: principalT },
      ],
      output: responseSimpleT(numberT),
      mode: 'readonly',
    },
    'route-helper': {
      input: [
        { name: 'token-x', type: principalT },
        { name: 'token-y', type: principalT },
      ],
      output: responseSimpleT(listT(principalT)),
      mode: 'readonly',
    },
  },
} as const);
