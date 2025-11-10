/** @type {import('next').NextConfig} */
const nextConfig = {
  reactCompiler: true,
  output: 'standalone',
  transpilePackages: ['@rainboot/shared'],
}

module.exports = nextConfig
