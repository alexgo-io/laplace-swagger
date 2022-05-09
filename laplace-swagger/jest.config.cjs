module.exports = {
  modulePathIgnorePatterns: ['/node_modules/', '/dist/'],
  preset: 'ts-jest',
  testEnvironment: './src/testing/emulator-test-env.js',
  setupFilesAfterEnv: [],
  testTimeout: 60000,
  transform: {},
  transformIgnorePatterns: ['\\.js$', '\\.jsx$', '\\.json$'],
  moduleFileExtensions: ['js', 'jsx', 'ts', 'tsx', 'json', 'd.ts'],
  detectOpenHandles: true,
  forceExit: true,
};
