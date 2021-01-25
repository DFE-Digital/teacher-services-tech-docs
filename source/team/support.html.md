---
category: Team things
title: Support on Apply
---

# Support on Apply

There’s one person from Apply (Candidate + ProVendor) on support every week.

We've got 3 important documents:

- The [regularly updated rota](https://docs.google.com/spreadsheets/d/1HnJFMMHwlTK167PgHHifrMl98-598zmyUuhsLNeufRU/edit#gid=0) keeps track of who's on support
- The [Apply Apply Support - Common tasks & Requests][pb] doc tells you what to do (and who should do it) for common situations
- The [Activity log][al] keeps track of all the things we do, so we can pick which things to automate

## What's the purpose of a "support dev"?

Things that a support dev does:

- Unblock support agents by answering questions
- Looking at Sentry errors
- Perform dev-only tasks like running scripts on production
- Improve the [support playbook][pb]
- Fill in the [activity log][al] for requests

And not:

- Fix all the issues - just triage, talk to someone to create a card on backlog

## Weekly handover

We do a handover on Mondays at 10:30.

Agenda:

- Say hi
- What happened last week?
- Update the Slack channel subject
- Schedule a handover for next week

## Before going on support

- Make sure you have Zendesk access, you can ask #digital-tools-support to be added as an agent to https://becomingateacher.zendesk.com
- Read the [activity log]() for the last week
- Be aware of [PIM guide for production access](/services/apply-for-teacher-training/pim-guide.html)

## Good practice when editing production data

Attach an [audit_comment field](https://github.com/collectiveidea/audited#comments) to any model updates. For example:

```rb
ApplicationReference.update!(
  name: 'Correct name',
  audit_comment: 'Correcting a name following a support request',
)
```

Include the Zendesk URL in the audit comment.

[pb]: https://docs.google.com/document/d/11e2Du1Xp8F6V8N70hvXe-yPn5kGG23ORtumeULM4mdM/edit
[al]: https://docs.google.com/spreadsheets/d/1PlYsIevfJfkDpyeAP9O5W6PARSc_T-D-9ag0rPL7vdQ/edit#gid=0
