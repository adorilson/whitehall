namespace :edition do
  desc "Unarchives an Edition by creating a draft and publishing it."
  task :unarchive, [:email, :edition_id] => :environment do |t,args|
    user = User.where(email: args[:email]).first
    edition = Edition.find args[:edition_id]

    raise "No user found for #{args[:email]}" unless user
    raise "No edition found for id #{args[:edition_id]}" unless edition

    edition.update_attribute(:state, 'published') # Otherwise create_draft fails
    edition.reload
    draft = edition.create_draft(user)
    edition.update_attribute(:state, 'archived')
    draft.change_note = "Draft copy of edition #{edition.id} (unarchived)"

    if EditionForcePublisher.new(draft).perform!
      puts "Unarchived Edition #{edition.id}. Newly published Edition is #{draft.id}"
    end
  end
end
