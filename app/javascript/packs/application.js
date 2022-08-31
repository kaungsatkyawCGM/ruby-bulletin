//= require jquery-3.5.1.min
//= require dataTables.bootstrap5.min
//= require jquery.dataTables.min
import Rails from "rails-ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

require("packs/user_list")
require("packs/import")