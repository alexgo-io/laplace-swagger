import { Log, Logging, protos } from '@google-cloud/logging';
import { hostname } from 'os';
import safeJsonStringify from 'safe-json-stringify';

export type SEVERITY = 'INFO' | 'WARNING' | 'ERROR' | 'NOTICE';

const gcpLog = (
  severity: SEVERITY,
  message: string,
  errorOrExtra?: any,
): void => {
  console.log(
    safeJsonStringify({
      severity,
      message,
      'logging.googleapis.com/trace': (errorOrExtra as any)?.stack,
    }),
  );
};

const consoleSeverityLogMethods: { [K in SEVERITY]: typeof console.log } = {
  INFO: console.info,
  WARNING: console.warn,
  ERROR: console.error,
  NOTICE: console.log,
};

const consoleLog: typeof gcpLog = (severity, message, errorOrExtra) => {
  const _log = consoleSeverityLogMethods[severity] || console.log;
  const args: any[] = [message];
  if (errorOrExtra) {
    args.push(errorOrExtra.stack ?? String(errorOrExtra));
  }
  _log(...args);
};

const getGcpLoggingClient = () => {
  const log: Log = new Logging().log(hostname());
  console.log('Sending logs to GCP Logging Service.');
  return (severity: SEVERITY, message: string, errorOrExtra?: any): void => {
    const metadata: Omit<
      protos.google.logging.v2.ILogEntry,
      'timestamp' | 'httpRequest'
    > = {
      severity,
      resource: {
        type: 'global',
      },
      labels: {
        service_name: 'laplace-sync',
      },
    };
    const data: any = { message };
    if (errorOrExtra instanceof Error) {
      metadata.trace = errorOrExtra.stack ?? errorOrExtra.message;
    } else {
      data.extra = errorOrExtra;
    }
    log.write(log.entry(metadata, data));
    consoleLog(severity, message, errorOrExtra);
  };
};

export const log =
  process.env.GOOGLE_APPLICATION_CREDENTIALS !== undefined
    ? getGcpLoggingClient()
    : process.env.K_SERVICE === undefined
    ? consoleLog
    : gcpLog;

export const info = log.bind(null, 'INFO');
export const error = log.bind(null, 'ERROR');
export const warn = log.bind(null, 'WARNING');
export const notice = log.bind(null, 'NOTICE');
export default Object.freeze({ log, info, error, warn, notice });
