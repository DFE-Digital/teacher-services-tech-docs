# Incident playbook

## Once an incident happens

### 1. Form an incident response team

Self-organise to appoint:

1.  the **Incident comms lead**
    (responsible for communicating and alerts to users and stakeholders)
2.  the **Incident tech lead**
    (responsible for technical direction and communicating to the comms lead)
3. the **Incident support lead**
    (responsible for monitoring Zendesk and alerting the team to any changes in the queues and severity of experience of users).

### 2. Triage the incident (all incident leads)

The incident leads should [triage the incident](/operating-a-service/how-to-categorise-technical-incidents.html) (P1, P2, P3).

### 3. Identify any other services involved (tech lead)

After triaging the issue, the tech lead should identify:

- any upstream services which could be contributing to the issue
- any downstream services likely to be affected by the issue and raise incidents where needed

### 4. Create an incident Slack channel and inform the stakeholders (comms lead)

1. Initiate the Slack IncidentBot by typing `/incident open` in the message box on the service Slack channel or #teacher-services-infra. Hit Enter.
2. Complete the details in the IncidentBot template, and press Enter, which will automatically create a dedicated Slack channel for the incident.
3. Determine who needs to be contacted, based on the incident priority and affected services. Use the contacts from the [Teacher services list](https://educationgovuk.sharepoint.com.mcas.ms/sites/teacher-services-infrastructure/Lists/Teacher%20services%20list/AllItems.aspx) and the incident contact list if you have one for your service. It may include critical user groups like lead providers. Make sure to include PDM, SRO, DD in case of a P1 incident.
4. Invite the appropriate people from the contact lists to the incident channel.

### 5. Provide a service update to users outside DfE (comms lead)

The Teacher Services team maintains a publicly available [service status dashboard](https://teacher-services-status.education.gov.uk/). During an incident, the comms lead needs to explain what’s happening to users outside DfE. The comms lead will need a GitHub account to do this, or delegate updates to a colleague who has one.

The updates are managed via GitHub Actions and issues on the [teacher-services-upptime repository on GitHub](https://github.com/DFE-Digital/teacher-services-upptime). If a service’s automatic health check is failing continuously, an issue will be created within 5 minutes of the failure occurring and the dashboard will start reporting a service issue.

To update the dashboard:

1. Navigate to the appropriate incident issue on the [GitHub issues page](https://github.com/DFE-Digital/teacher-services-upptime/issues)
2. Add a comment to the issue

### 6. Start the incident report (any incident lead)

Create the incident report using the template in Sharepoint:

- Create a running [Incident Report using this template](https://educationgovuk.sharepoint.com/:w:/r/sites/TeacherServices/Shared%20Documents/Incidents/Incident%20report%20template.docx?d=w492d660483b642d3ba573293b133ff1c&csf=1&web=1&e=mW0xQJ)
- Rename the created file to include today’s date and save as a new file in the [Incident reports folder](https://educationgovuk.sharepoint.com/:f:/r/sites/TeacherServices/Shared%20Documents/Incidents/Reports?csf=1&web=1&e=IgTclP)

### 7. Decide whether to contact users about an incident (support lead)

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

Use the Slack IncidentBot `/incident update` command to update:

- Description
- Priority
- Leads

### Provide regular updates every 60 minutes (comms lead)

Update stakeholders on the Slack incident channel every 60 minutes, until the incident has been resolved. Ensure they receive the alert even if their Slack alert notifications are turned off, and check in with them face-to-face (once back in the office).

## Once the incident is resolved

1. Update the running incident report
2. Close the incident on using `/incident close` command in Slack
3. Confirm that the incident has been automatically resolved on the [service status dashboard](https://teacher-services-status.education.gov.uk/) (it may take 5 mins to update)
4. If this was a P1 incident, then it needs to be reported as a Major Incident to the central DfE team. See [Reporting a Major incident](https://educationgovuk.sharepoint.com/:w:/r/sites/TeacherServices/Shared%20Documents/Incidents/Reporting%20an%20Incident%20as%20a%20Major%20Incident.docx?d=w20b0829dd7884ecf8db8ea587d416fb6&csf=1&web=1&e=nyb9tL)

## Incident review

1. Hold an incident and lesson learned review following a [blameless post mortem culture](https://codeascraft.com/2012/05/22/blameless-postmortems/) so your service can improve.
  1. Write up an incident review with recommendations.
  2. The report introduction should be written in plain English, avoiding technical jargon whenever possible.
2. Publish the incident review to the [incident reports folder in Sharepoint](https://educationgovuk.sharepoint.com/:f:/r/sites/TeacherServices/Shared%20Documents/Incidents/Reports?csf=1&web=1&e=IgTclP).
3. Report on the incident as part of the A3 report to the Teacher Services Board.
4. If this was a P1, update the previously created Major incident report with any lessons learnt. See [Reporting a Major incident](https://educationgovuk.sharepoint.com/:w:/r/sites/TeacherServices/Shared%20Documents/Incidents/Reporting%20an%20Incident%20as%20a%20Major%20Incident.docx?d=w20b0829dd7884ecf8db8ea587d416fb6&csf=1&web=1&e=nyb9tL)
