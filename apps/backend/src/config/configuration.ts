export default () => ({
  port: parseInt(process.env.PORT || '4000', 10) || 4000,
  apiPrefix: process.env.API_GLOBAL_PREFIX || '/api',
  nodeEnv: process.env.NODE_ENV || 'development',
  corsOrigin: process.env.CORS_ORIGIN || 'http://localhost:3000',

  supabase: {
    url: process.env.SUPABASE_URL || '',
    publishableKey: process.env.SUPABASE_PUBLISHABLE_KEY || '',
    secretKey: process.env.SUPABASE_SECRET_KEY || '',
  },

  redis: {
    url: process.env.REDIS_URL || 'redis://localhost:6379',
  },

  jwt: {
    secret: process.env.JWT_SECRET || '',
    accessTokenExpiration:
      parseInt(process.env.JWT_ACCESS_TOKEN_EXPIRATION || '3600', 10) || 3600,
  },

  sentry: {
    dsn: process.env.SENTRY_DSN || '',
    environment: process.env.SENTRY_ENVIRONMENT || 'development',
  },

  posthog: {
    apiKey: process.env.POSTHOG_API_KEY || '',
    host: process.env.POSTHOG_HOST || 'https://app.posthog.com',
  },

  throttle: {
    ttl: parseInt(process.env.THROTTLE_TTL || '60', 10) || 60,
    limit: parseInt(process.env.THROTTLE_LIMIT || '10', 10) || 10,
  },

  winston: {
    logLevel: process.env.WINSTON_LOG_LEVEL || 'info',
    logPath: process.env.WINSTON_LOG_PATH || 'logs/app.log',
  },

  defaults: {
    currency: process.env.DEFAULT_CURRENCY || 'VND',
    locale: process.env.DEFAULT_LOCALE || 'vi-VN',
    timezone: process.env.DEFAULT_TIMEZONE || 'Asia/Ho_Chi_Minh',
  },

  thirdParty: {
    googleClientId: process.env.GOOGLE_CLIENT_ID || '',
    googleClientSecret: process.env.GOOGLE_CLIENT_SECRET || '',

    facebookClientId: process.env.FACEBOOK_CLIENT_ID || '',
    facebookClientSecret: process.env.FACEBOOK_CLIENT_SECRET || '',
  },
});
