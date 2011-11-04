Feature: Editing draft policies
In order to send the best version of a policy to the departmental editor
A writer
Should be able to edit and save draft policies

Background:
  Given I am a writer

Scenario: Creating a new draft policy
  When I draft a new policy "Outlaw Moustaches"
  Then I should see the policy "Outlaw Moustaches" in the list of draft documents

Scenario: Creating a new draft policy in multiple topics
  Given two topics "Facial Hair" and "Hirsuteness" exist
  When I draft a new policy "Outlaw Moustaches" in the "Facial Hair" and "Hirsuteness" topics
  Then I should see in the preview that "Outlaw Moustaches" should be in the "Facial Hair" and "Hirsuteness" topics

Scenario: Creating a new draft policy in multiple organisations
  Given two organisations "Department of Paperclips" and "Stationery Standards Authority" exist
  When I draft a new policy "Ban Tinfoil Paperclips" in the "Department of Paperclips" and "Stationery Standards Authority" organisations
  Then I should see in the preview that "Ban Tinfoil Paperclips" should be in the "Department of Paperclips" and "Stationery Standards Authority" organisations

Scenario: Creating a new draft policy that's the responsibility of multiple ministers
  Given ministers exist:
    | Ministerial Role    | Person     |
    | Minister of Finance | John Smith |
    | Treasury Secretary  | Jane Doe   |
  When I draft a new policy "Pinch more pennies" associated with "John Smith (Minister of Finance)" and "Jane Doe (Treasury Secretary)"
  Then I should see in the preview that "Pinch more pennies" is associated with "John Smith (Minister of Finance)" and "Jane Doe (Treasury Secretary)"

Scenario: Creating a new draft policy that applies to multiple nations
  When I draft a new policy "Outlaw Moustaches" that does not apply to the nations:
    | Scotland | Wales |
  Then I should see in the preview that "Outlaw Moustaches" does not apply to the nations:
    | Scotland | Wales |

Scenario: Adding a supporting document to a draft policy
  Given a draft policy "Outlaw Moustaches" exists
  When I add a supporting document "Handlebar Waxing" to the "Outlaw Moustaches" policy
  Then I should see in the preview that "Outlaw Moustaches" includes the "Handlebar Waxing" supporting document
  And I should see in the list of draft documents that "Outlaw Moustaches" has supporting document "Handlebar Waxing"

Scenario: Editing an existing draft policy
  Given a draft policy "Outlaw Moustaches" exists
  When I edit the policy "Outlaw Moustaches" changing the title to "Ban Moustaches"
  Then I should see the policy "Ban Moustaches" in the list of draft documents

Scenario: Editing an existing draft policy assigning multiple topics
  Given two topics "Facial Hair" and "Hirsuteness" exist
  And a draft policy "Outlaw Moustaches" exists in the "Facial Hair" topic
  When I edit the policy "Outlaw Moustaches" adding it to the "Hirsuteness" topic
  Then I should see in the preview that "Outlaw Moustaches" should be in the "Facial Hair" and "Hirsuteness" topics

Scenario: Editing an existing supporting document
  Given a supporting document "Handlebar Waxing" exists on a draft policy "Outlaw Moustaches"
  When I edit the supporting document "Handlebar Waxing" changing the title to "Waxing Dangers"
  Then I should see in the preview that "Outlaw Moustaches" includes the "Waxing Dangers" supporting document

Scenario: Trying to save a policy that has been changed by another user
  Given a draft policy "Outlaw Moustaches" exists
  And I start editing the policy "Outlaw Moustaches" changing the title to "Ban Moustaches"
  And another user edits the policy "Outlaw Moustaches" changing the title to "Ban Beards"
  When I save my changes to the policy
  Then I should see the conflict between the policy titles "Ban Moustaches" and "Ban Beards"
  When I edit the policy changing the title to "Ban Moustaches and Beards"
  Then I should see the policy "Ban Moustaches and Beards" in the list of draft documents

Scenario: Trying to save a supporting document that has been changed by another user
  Given a supporting document "Handlebar Waxing" exists on a draft policy "Outlaw Moustaches"
  And I start editing the supporting document "Handlebar Waxing" changing the title to "Waxing Dangers"
  And another user edits the supporting document "Handlebar Waxing" changing the title to "Something Else"
  When I save my changes to the supporting document
  Then I should see the conflict between the supporting document titles "Waxing Dangers" and "Something Else"
  When I edit the supporting document changing the title to "Waxing Dangers and Something Else"
  Then I should see in the preview that "Outlaw Moustaches" includes the "Waxing Dangers and Something Else" supporting document

Scenario: Submitting a draft policy to a second pair of eyes
  Given a draft policy "Outlaw Moustaches" exists
  When I submit the policy "Outlaw Moustaches"
  Then I should see the policy "Outlaw Moustaches" in the list of submitted documents

Scenario: Deleting a draft policy that has not been published
  Given a draft policy "Outlaw All Body Hair" exists
  When I delete the draft policy "Outlaw All Body Hair"
  Then I should not see the policy "Outlaw All Body Hair" in the list of draft documents

Scenario: Editing a draft policy that's been submitted to a second pair of eyes
  Given a submitted policy titled "The policy"
  And I am an editor
  When I edit the policy "The policy" changing the title to "The new policy"
  Then I should see the policy "The new policy" in the list of submitted documents