import * as stacks from '@stacks/network';

export const STACKS_NODE_TYPE:
  | 'StacksMainnet'
  | 'StacksMocknet'
  | 'StacksTestnet' = '{{STACKS_NODE_TYPE}}' as any;

export const STACKS_NETWORK = new stacks[STACKS_NODE_TYPE]({
  url: process.env.STACKS_NODE_ADDRESS ?? '{{STACKS_NODE_ADDRESS}}',
});

export const STACKS_DEPLOYER_ADDRESS =
  process.env.STACKS_DEPLOYER_ADDRESS ?? '{{STACKS_DEPLOYER_ADDRESS}}';

export const ESTIMATED_BLOCK_DURATION =
  process.env.ESTIMATED_BLOCK_DURATION ?? '{{ESTIMATED_BLOCK_DURATION}}';

export const ALEX_CONTRACT_NAME_LAUNCHPAD =
  process.env.ALEX_CONTRACT_NAME_LAUNCHPAD ?? '{{ALEX_CONTRACT_NAME_LAUNCHPAD}}';
