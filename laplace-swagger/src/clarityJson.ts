export enum ClarityJsonType {
  Boolean = 'Boolean',
  Int = 'Int',
  UInt = 'UInt',
  Buffer = 'Buffer',
  OptionalNone = 'OptionalNone',
  OptionalSome = 'OptionalSome',
  ResponseOk = 'ResponseOk',
  ResponseErr = 'ResponseErr',
  PrincipalStandard = 'PrincipalStandard',
  PrincipalContract = 'PrincipalContract',
  List = 'List',
  Tuple = 'Tuple',
  StringASCII = 'StringASCII',
  StringUTF8 = 'StringUTF8',
  ParseError = 'ParseError',
}

export type BooleanCVJson = {
  type: ClarityJsonType.Boolean;
  value: boolean;
};

export type IntCVJson = {
  type: ClarityJsonType.Int;
  value: number;
};

export type UIntCVJson = {
  type: ClarityJsonType.UInt;
  value: number;
};

export type BufferCVJson = {
  type: ClarityJsonType.Buffer;
  value: string;
};

export type NoneCVJson = {
  type: ClarityJsonType.OptionalNone;
  value: null;
};
export type SomeCVJson = {
  type: ClarityJsonType.OptionalSome;
  value: ClarityJsonValue;
};

export type ResponseOkCVJson = {
  type: ClarityJsonType.ResponseOk;
  value: ClarityJsonValue;
};

export type ResponseErrorCVJson = {
  type: ClarityJsonType.ResponseErr;
  value: ClarityJsonValue;
};
export type PrincipalStandardCVJson = {
  type: ClarityJsonType.PrincipalStandard;
  value: string;
};

export type PrincipalContractCVJson = {
  type: ClarityJsonType.PrincipalContract;
  value: string;
};

export type ListCVJson = {
  type: ClarityJsonType.List;
  value: ClarityJsonValue[];
};

export type TupleCVJson = {
  type: ClarityJsonType.Tuple;
  value: { [key: string]: ClarityJsonValue };
};

export type StringASCIICVJson = {
  type: ClarityJsonType.StringASCII;
  value: string;
};

export type StringUTF8CVJson = {
  type: ClarityJsonType.StringUTF8;
  value: string;
};

export type ParseErrorCVJson = {
  type: ClarityJsonType.ParseError;
  value: null | string;
};

export type ClarityJsonValue =
  | BooleanCVJson
  | IntCVJson
  | UIntCVJson
  | BufferCVJson
  | NoneCVJson
  | SomeCVJson
  | ResponseOkCVJson
  | ResponseErrorCVJson
  | PrincipalStandardCVJson
  | PrincipalContractCVJson
  | ListCVJson
  | TupleCVJson
  | StringASCIICVJson
  | StringUTF8CVJson;
