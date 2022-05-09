import {
  callReadOnlyFunction,
  cvToHex,
  deserializeCV,
  ReadOnlyFunctionOptions,
} from '@stacks/transactions';
import axios from 'axios';
import {
  MapEntryDescriptor,
  ParameterObjOfDescriptor,
  ReadonlyFunctionDescriptor,
  ReturnTypeOfDescriptor,
  VariableDescriptor,
} from 'clarity-codegen';
import safeJsonStringify from 'safe-json-stringify';
import { YQueue } from 'yqueue';
import { STACKS_DEPLOYER_ADDRESS, STACKS_NETWORK } from '../config/stacks';
import logger from '../logger';
import { AlexContracts } from './generated/contracts_Alex';

export type Contracts = typeof AlexContracts;
export type ContractName = keyof Contracts;
const DEFAULT_TIMEOUT = 30000;
const STACKS_NODE_REQUEST_CONCURRENCY_LIMIT = parseInt(
  process.env.STACKS_NODE_REQUEST_CONCURRENCY_LIMIT ?? '64',
  10,
);
const queue = new YQueue({
  concurrency: STACKS_NODE_REQUEST_CONCURRENCY_LIMIT,
});

export function alexPrincipal<T extends ContractName>(contract: T) {
  return `${STACKS_DEPLOYER_ADDRESS}.${contract}`;
}

export interface UseContractWrapper<T extends keyof Contracts> {
  func: <F extends keyof Contracts[T]>(
    functionName: F,
  ) => {
    call: <Descriptor extends Contracts[T][F]>(
      senderAddress: string,
      args: Descriptor extends ReadonlyFunctionDescriptor
        ? ParameterObjOfDescriptor<Descriptor>
        : never,
    ) => Promise<
      Descriptor extends ReadonlyFunctionDescriptor
        ? ReturnTypeOfDescriptor<Descriptor>
        : never
    >;
  };
  map: <K extends keyof Contracts[T]>(
    mapName: K,
  ) => {
    get: <Descriptor extends Contracts[T][K]>(
      key: Descriptor extends MapEntryDescriptor
        ? ParameterObjOfDescriptor<Descriptor>
        : never,
      options?: {
        proof?: boolean;
        indexBlockHash?: string;
        timeout?: number;
      },
    ) => Promise<
      Descriptor extends MapEntryDescriptor
        ? ReturnTypeOfDescriptor<Descriptor>
        : never
    >;
  };
  data: <K extends keyof Contracts[T]>(
    dataEntryName: K,
  ) => {
    get: <Descriptor extends Contracts[T][K]>(options?: {
      proof?: boolean;
      indexBlockHash?: string;
      timeout?: number;
    }) => Promise<
      Descriptor extends VariableDescriptor
        ? ReturnTypeOfDescriptor<Descriptor>
        : never
    >;
  };
}

export const useContract = <T extends keyof Contracts>(
  contract: T,
): UseContractWrapper<T> => ({
  func: functionName => ({
    call: (senderAddress, args) =>
      queue.run(async () => {
        if (senderAddress == null) {
          throw new Error(`senderAddress is not set`);
        }
        const functionDescriptor = AlexContracts[contract][
          functionName
        ] as any as ReadonlyFunctionDescriptor;
        const clarityArgs = functionDescriptor.input.map(arg =>
          arg.type.encode(args[arg.name]),
        );
        const sharedOptions: ReadOnlyFunctionOptions = {
          network: STACKS_NETWORK,
          contractName: contract,
          contractAddress: STACKS_DEPLOYER_ADDRESS,
          functionName: String(functionName),
          functionArgs: clarityArgs,
          senderAddress,
        } as const;
        logger.info(
          `Calling readonly ${contract}.${functionName} with args: ${safeJsonStringify(
            args,
          )}`,
        );
        const result = await callReadOnlyFunction({
          ...sharedOptions,
        });
        const value = functionDescriptor.output.decode(result);
        logger.info(
          `Finished readonly ${contract}.${functionName} with response: ${safeJsonStringify(
            value,
          )}`,
        );
        return value;
      }),
  }),
  map: mapName => ({
    get: (key, options) =>
      queue.run(async () => {
        const params = new URLSearchParams();
        params.set('proof', options?.proof === true ? '1' : '0');
        if (typeof options?.indexBlockHash === 'string') {
          params.set('tip', options?.indexBlockHash);
        }
        const url = `${
          STACKS_NETWORK.coreApiUrl
        }/v2/map_entry/${STACKS_DEPLOYER_ADDRESS}/${contract}/${mapName}?${params.toString()}`;

        const mapDescriptor = AlexContracts[contract][
          mapName
        ] as any as MapEntryDescriptor;
        const body = cvToHex(mapDescriptor.input.encode(key));
        const mapResponse: { data: { data: string } } = await axios.post(
          url,
          `"${body}"`,
          {
            headers: { 'Content-Type': 'application/json' },
            timeout: options?.timeout ?? DEFAULT_TIMEOUT,
          },
        );
        const rs = deserializeCV(mapResponse.data.data);
        return mapDescriptor.output.decode(rs);
      }),
  }),
  data: dataEntryName => ({
    get: options =>
      queue.run(async () => {
        const params = new URLSearchParams();
        params.set('proof', options?.proof === true ? '1' : '0');
        if (typeof options?.indexBlockHash === 'string') {
          params.set('tip', options?.indexBlockHash);
        }
        const url = `${
          STACKS_NETWORK.coreApiUrl
        }/v2/data_var/${STACKS_DEPLOYER_ADDRESS}/${contract}/${dataEntryName}?${params.toString()}`;

        const variableDescriptor = AlexContracts[contract][
          dataEntryName
        ] as any as VariableDescriptor;
        const mapResponse: { data: { data: string } } = await axios.get(url, {
          headers: { 'Content-Type': 'application/json' },
          timeout: options?.timeout ?? DEFAULT_TIMEOUT,
        });
        const rs = deserializeCV(mapResponse.data.data);
        return variableDescriptor.output.decode(rs);
      }),
  }),
});
