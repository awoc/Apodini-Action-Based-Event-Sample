import Notifications
import Jobs
import Apodini

struct Server: WebService {
    var content: some Component {
        Text("Hello World!")
    }
}

try Server.main()
