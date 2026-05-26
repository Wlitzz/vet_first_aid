# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative "config/application"

Rails.application.load_tasks

# Remove Tailwind CSS build from test:prepare on Windows where
# lightningcss native modules may fail to load.
Rake::Task["test:prepare"].prerequisites.delete("tailwindcss:build") if Rake::Task.task_defined?("tailwindcss:build")
