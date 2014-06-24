bathroom-monitor
================

TableXI's own bathroom monitor - complete with Raspberry Pi!

Uses:

- Ruby version 2.1.2
- MySQL

See `Gemfile` for the list of required gems.

---

How does it work?
-----------------

1. Right now, there is a Raspberry Pi in the Kitchen, which reads if the door is open or closed, every 10 seconds.

2. Regardless of status, the Raspberry Pi posts this data to `/update`, with a shared secret key, updating the status of the website, if necessary.

3. Users connect to directory index, and are met with an auto-updating page, showing if the bathroom is vacant or occupied.

4. If they so please, Users can very "Potty Statistics" over on `/statistics`

---

How do I get up and running?
----------------------------

1. Copy `config/database.yml.template` over to `config/database.yml` and make necessary adjustments

2. Copy `config/access_key.yml.template` over to `config/access_key.yml`, and customize your access key with a quick faceroll on the keyboard.

3. Run `gem install bundler` if you don't have the `bundler` gem.

4. Run `bundle install` real quick to make sure have all of the required gems for the bathroom monitor

5. Run `rake db:create db:migrate db:seed` to create, migrate, and seed the database

6. Run `rails server` to start the test server.

7. (Optional) Install useful control scripts
    1. Copy `scripts/occupied.sh.example` and `scripts/vacant.sh.example` over to `scripts/occupied.sh` and `scripts/vacant.sh`
    2. Update both scripts to include your secret key from step (2).
    3. Run `brew install curl` if you don't have cURL.
    4. To update the status, run `./scripts/occupied.sh` or `./scripts/vacant.sh` while the server is running
