import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";



const LockModule = buildModule("LockModule", (m) => {
  

  const lock = m.contract("VotingSystem");

  return { lock };
});

export default LockModule;
