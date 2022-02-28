# Incident playbook

## Once an incident happens

### 1. Form an incident response team

Self-organise to appoint:

1.  the **Incident comms lead**
    (responsible for communicating and alerts to users and stakeholders)
2.  the **Incident tech lead**
    (responsible for technical direction and communicating to the comms lead)
3. the **Incident support lead**, when the incident involves a public-facing service
    (responsible for monitoring Zendesk and alerting the team to any changes in the queues and severity of experience of users).

### 2. Triage the incident (all incident leads)

The incident leads should [triage the incident](/operating-a-service/how-to-categorise-technical-incidents.html) (P1, P2, P3).

### 3. Create an incident Slack channel and inform the stakeholders (comms lead)

1. Initiate the Slack IncidentBot by typing `/incident` in the message box on #twd_git_bat channel or the #tra_digital channel (as appropriate), and hit Enter.
2. Complete the details in the IncidentBot template, and press Enter, which will automatically create a dedicated slack channel for the incident.
3. Determine who needs to be contacted, based on the incident priority and affected services, using [the incident contact lists](https://docs.google.com/document/d/1E3sL-Om_NPHWHdYdLykVuiWux_6AmR5pn5KjIkQYHaI/edit#bookmark=id.djbosiwhbjjy).
4. @tag the appropriate people (from the tables linked below) in the dedicated channel:

### 4. Provide a service update to users outside DfE (comms lead)

The Teacher Services team maintains a publicly available [service status dashboard](https://teacher-services-status.education.gov.uk/). During an incident, the comms lead needs to explain what’s happening to users outside DfE. The comms lead will need a GitHub account to do this, or delegate updates to a colleague who has one.

The updates are managed via GitHub Actions and issues on the [teacher-services-upptime repository on GitHub](https://github.com/DFE-Digital/teacher-services-upptime). If a service’s automatic health check is failing continuously, an issue will be created within 5 minutes of the failure occurring and the dashboard will start reporting a service issue.

To update the dashboard:

1. Navigate to the appropriate incident issue on the [GitHub issues page](https://github.com/DFE-Digital/teacher-services-upptime/issues)
2. Add a comment to the issue

### 5. Start the incident report (any incident lead)

Create the incident report using the template in Google Drive:

- Create a running [Incident Report using this template](https://docs.google.com/document/d/1HwKCPafnluOIhIAWbSD91zxt7w3q4FGDIVKS3d_SDFA/edit?usp=sharing)
- Rename the created file to include today’s date and save as a new file in the [Incident reports folder](https://drive.google.com/drive/folders/12uWIF4beypUpEjejTRcKtV2PFadT5met)

### 6. Decide whether to contact users about an incident (support lead)

Contact your users if:

* The incident will negatively impact them for a prolonged period of time
* It can pre-empt a high volume of support tickets

Informing users about incidents is generally considered best practice, but should be decided on a case by case basis with the product and service managers.

## While the incident is in progress (all incident leads)

Keep all conversations and status updates about the incident on the dedicated Slack incident channel.

Use these incident stages in your Slack updates:

- Incident has occurred
- Incident is being assessed
- Incident is being fixed
- Incident is resolved

Use the Slack IncidentBot `/update` command to update:

- Description
- Priority
- Leads

### Provide regular updates every 60 minutes (comms lead)

Update stakeholders on the Slack incident channel every 60 minutes, until the incident has been resolved. Ensure they receive the alert even if their Slack alert notifications are turned off, and check in with them face-to-face (once back in the office).

## Once the incident is resolved

1. Update the running incident report
2. Close the incident on using `/closeincident` command in Slack
3. Confirm that the incident has been automatically resolved on the service status dashboard (it may take 5 mins to update)

## Incident review

1. Hold an incident and lesson learned review following a [blameless post mortem culture](https://codeascraft.com/2012/05/22/blameless-postmortems/) so your service can improve.
  1. Write up an incident review with recommendations.
  2. The report introduction should be written in plain English, avoiding technical jargon whenever possible.
2. Publish the incident review to the [incident reports folder in Google Drive](https://drive.google.com/drive/folders/12uWIF4beypUpEjejTRcKtV2PFadT5met).
3. Report on the incident as part of the A3 report to the Teacher Services Board.

## Related links

[GIT/BAT incident alerting and service support during holiday periods](https://docs.google.com/document/d/1Jo6lgN1_V3iCLE-sc950pgZ6RE1YuqU6uP3m7Smw15U/edit)
