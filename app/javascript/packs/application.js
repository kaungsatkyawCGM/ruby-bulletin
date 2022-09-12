import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"

Turbolinks.start()
ActiveStorage.start()
require("packs/user_list")
require("packs/import")
require("packs/post_list")
