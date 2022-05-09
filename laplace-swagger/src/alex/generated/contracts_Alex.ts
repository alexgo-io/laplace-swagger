import { defineContract } from 'clarity-codegen';
import { age000GovernanceToken } from './contract_age000-governance-token';
import { alexLaunchpadV11 } from './contract_alex-launchpad-v1-1';
import { alexReservePool } from './contract_alex-reserve-pool';
import { alexVault } from './contract_alex-vault';
import { autoAlex } from './contract_auto-alex';
import { dualFarmDikoHelper } from './contract_dual-farm-diko-helper';
import { dualFarmingPool } from './contract_dual-farming-pool';
import { fixedWeightPoolV101 } from './contract_fixed-weight-pool-v1-01';
import { fwpAlexAutoalex } from './contract_fwp-alex-autoalex';
import { fwpAlexUsda } from './contract_fwp-alex-usda';
import { fwpAlexWban } from './contract_fwp-alex-wban';
import { fwpAlexWmia } from './contract_fwp-alex-wmia';
import { fwpAlexWnycc } from './contract_fwp-alex-wnycc';
import { fwpAlexWslm } from './contract_fwp-alex-wslm';
import { fwpWstxAlex5050V101 } from './contract_fwp-wstx-alex-50-50-v1-01';
import { fwpWstxWbtc5050V101 } from './contract_fwp-wstx-wbtc-50-50-v1-01';
import { fwpWstxWxusd5050V101 } from './contract_fwp-wstx-wxusd-50-50-v1-01';
import { multisigFwpAlexUsda } from './contract_multisig-fwp-alex-usda';
import { multisigFwpAlexWban } from './contract_multisig-fwp-alex-wban';
import { multisigFwpAlexWslm } from './contract_multisig-fwp-alex-wslm';
import { multisigFwpWstxAlex5050V101 } from './contract_multisig-fwp-wstx-alex-50-50-v1-01';
import { multisigFwpWstxWbtc5050V101 } from './contract_multisig-fwp-wstx-wbtc-50-50-v1-01';
import { simpleWeightPoolAlex } from './contract_simple-weight-pool-alex';
import { stakingHelper } from './contract_staking-helper';
import { swapHelper } from './contract_swap-helper';
import { swapHelperV101 } from './contract_swap-helper-v1-01';
import { tokenApower } from './contract_token-apower';
import { tokenMia } from './contract_token-mia';
import { tokenNycc } from './contract_token-nycc';
import { tokenWban } from './contract_token-wban';
import { tokenWbtc } from './contract_token-wbtc';
import { tokenWdiko } from './contract_token-wdiko';
import { tokenWmia } from './contract_token-wmia';
import { tokenWnycc } from './contract_token-wnycc';
import { tokenWslm } from './contract_token-wslm';
import { tokenWstx } from './contract_token-wstx';
import { tokenWusda } from './contract_token-wusda';
import { tokenWxusd } from './contract_token-wxusd';

export const AlexContracts = defineContract({
  ...alexReservePool,
  ...autoAlex,
  ...dualFarmingPool,
  ...alexLaunchpadV11,
  ...fixedWeightPoolV101,
  ...simpleWeightPoolAlex,
  ...alexVault,
  ...swapHelper,
  ...stakingHelper,
  ...swapHelperV101,
  ...age000GovernanceToken,
  ...autoAlex,
  ...tokenApower,
  ...tokenWstx,
  ...tokenWban,
  ...tokenWbtc,
  ...tokenWusda,
  ...tokenWxusd,
  ...tokenWdiko,
  ...tokenWslm,
  ...tokenMia,
  ...tokenWmia,
  ...tokenNycc,
  ...tokenWnycc,
  ...fwpWstxAlex5050V101,
  ...fwpWstxWbtc5050V101,
  ...fwpWstxWxusd5050V101,
  ...fwpAlexUsda,
  ...fwpAlexWban,
  ...fwpAlexAutoalex,
  ...fwpAlexWslm,
  ...fwpAlexWmia,
  ...fwpAlexWnycc,
  ...multisigFwpWstxWbtc5050V101,
  ...multisigFwpWstxAlex5050V101,
  ...multisigFwpAlexUsda,
  ...multisigFwpAlexWban,
  ...multisigFwpAlexWslm,
  ...dualFarmDikoHelper,
});
