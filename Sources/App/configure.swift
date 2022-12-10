import Leaf
import QueuesRedisDriver
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.views.use(.leaf)

    // NOTE: Use "redis://localhost" when working locally
    guard let redisURL: String = Environment.get("REDIS_URL") else {
        throw ClarineteError.wrongRedisURL
    }

    // Redis Queues, for jobs
    try app.queues.use(.redis(url: redisURL))

    // Redis, for cache
    app.redis.configuration = try RedisConfiguration(url: redisURL)

    // Refresh Clarinete data every 10 minutes
    app.queues.schedule(FetchJob()).hourly().at(0)
    app.queues.schedule(FetchJob()).hourly().at(10)
    app.queues.schedule(FetchJob()).hourly().at(20)
    app.queues.schedule(FetchJob()).hourly().at(30)
    app.queues.schedule(FetchJob()).hourly().at(40)
    app.queues.schedule(FetchJob()).hourly().at(50)

    // register routes
    try routes(app)
}
