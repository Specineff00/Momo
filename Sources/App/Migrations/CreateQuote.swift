import Fluent

struct CreateQuotes: AsyncMigration {
    func prepare(on database: Database) async throws {
        // Create the table
        try await database.schema("quotes")
            .id()
            .field("text", .string, .required)
            .field("author", .string)
            .field("category", .string, .required)
            .create()

        // Seed with initial data
        let initialQuotes = [
            Quote(
                text: "If I cannot do great things, I can do small things in a great way",
                author: "Author 1"
            ),
            Quote(
                text: "Be the change that you wish to see in the world.",
                author: "Mahatma Ghandi"
            ),
            Quote(
                text: "The secret of getting ahead is getting started.",
                author: "Mark Twain"
            ),
            Quote(
                text: "Winners never quit, and quitters never win.",
                author: "Vince Lombardi"
            ),
            Quote(
                text: "The best way to predict the future is to create it.",
                author: "Abraham Lincoln"
            ),
            Quote(
                text: "The question isn't who is going to let me; it's who is going to stop me.",
                author: "Ayn Rand"
            ),
            Quote(
                text: "Do what you have to do until you can do what you want to do.",
                author: "Oprah Winfrey"
            ),

            Quote(
                text: "You can never cross the ocean until you have the courage to lose sight of the shore.",
                author: "Christopher Columbus"
            ),

            Quote(
                text: "One way to keep momentum going is to have constantly greater goals.",
                author: "Michael Korda"
            ),

            Quote(
                text: "You don't have to see the whole staircase, just take the first step.",
                author: "Martin Luther King Jr."
            ),

            Quote(
                text: "We are what we repeatedly do. Excellence, then, is not an act, but a habit.",
                author: "Aristotle"
            ),

            Quote(
                text: "God always strives together with those who strive.",
                author: "Aeschylus"
            ),

            Quote(
                text: "Change your thoughts and you change your world.",
                author: "Norman Vincent Peale"
            ),

            Quote(
                text: "It's hard to beat a person who never gives up.",
                author: "Babe Ruth"
            ),

            Quote(
                text: "The only person you should try to be better than, is the person you were yesterday.",
                author: "Matty Mullens"
            ),

            Quote(
                text: "Never give up, for that is just the place and time that the tide will turn.",
                author: "Harriet Beecher Stow"
            ),

            Quote(
                text: "The difference between a stumbling block and a stepping stone is how high you raise your foot.",
                author: "Benny Lewis"
            ),

            Quote(
                text: "Study while others are sleeping; work while others are loafing; prepare while others are playing; and dream while others are wishing.",
                author: "William Arthur Ward"
            ),

            Quote(
                text: "The difference between the impossible and the possible lies in a person's determination.",
                author: "Tommy Lasorda"
            ),

            Quote(
                text: "More powerful than the will to win is the courage to begin.",
                author: "Orrin Woodward"
            ),

            Quote(
                text: "Don't be pushed by your problems; be led by your dreams.",
                author: "Ralph Waldo Emerson"
            ),

            Quote(
                text: "You don't drown by falling in water; you drown by staying there.",
                author: "Robert Collier"
            ),

            Quote(
                text: "If you're going through hell, keep going",
                author: "Winston Churchill"
            ),

            Quote(
                text: "Better to do something imperfectly than to do nothing flawlessly.",
                author: "Robert Schuller"
            ),
        ]

        for quote in initialQuotes {
            try await quote.create(on: database)
        }
    }

    func revert(on database: Database) async throws {
        try await database.schema("quotes").delete()
    }
}
