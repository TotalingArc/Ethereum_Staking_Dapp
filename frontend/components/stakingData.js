import styles from "../styles/Home.module.css";

export default function StakingData() {
  return (
    <section className={styles.stakingDataContainer}>
      <section className={styles.stakingData}>
        <span>Total Staked Tokens</span>
        <span className={styles.stakingData_value}>$</span>
      </section>
      <section className={styles.stakingData}>
        <span>Total Renewal Paid</span>
        <span className={styles.stakingData_value}>$</span>
      </section>
      <section className={styles.stakingData}>
        <span>Stakers</span>
        <span className={styles.stakingData_value}>92,783</span>
      </section>
    </section>
  );
}
