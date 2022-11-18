import Leaf
import QueuesRedisDriver
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.views.use(.leaf)

    app.http.client.configuration.timeout = .init(
        connect: .seconds(5),
        read: .seconds(5)
    )

    guard let redisURL: String = Environment.get("REDIS_URL") else {
        throw ClarineteError.wrongRedisURL
    }

    // Redis Queues, for jobs
    try app.queues.use(.redis(url: redisURL))

    // Redis, for cache
    app.redis.configuration = try RedisConfiguration(url: redisURL)

    // Refresh Clarinete data every hour
    app.queues.schedule(FetchJob())
        .hourly()
        .at(0)

    // register routes
    try routes(app)
}
