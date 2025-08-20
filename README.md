![CloudResumeChallenge vpd](https://user-images.githubusercontent.com/111187499/195946326-07c4d65d-3758-494c-9d39-6f2a84d4f85a.jpg)


For more info on the Cloud Resume Challenge and the objectives of this project:

https://cloudresumechallenge.dev/docs/the-challenge/aws/

Front-end repo is located here:

https://github.com/matthew-ivancic/CRCFrontEnd

On commit to staging, the following tests are run:

1) [Cypress Test](https://github.com/matthew-ivancic/CloudResumeChallenge/blob/main/.github/workflows/cypress.yml) action will run, which checks existing code against [cypress tests](https://github.com/matthew-ivancic/CloudResumeChallenge/blob/main/cypress/e2e/CloudResumeChallenge.cy.js)

2) [Terraform Plan](https://github.com/matthew-ivancic/CloudResumeChallenge/blob/main/.github/workflows/terraform_plan.yml) action will also run, which formats and verifies terraform state, and executes terraform plan against it (results are available in the finished job

Once both tests have been passed and any terraform state changes have been reviewed, Staging branch can be committed against main. Once commited to main:

1) [Terraform Apply](https://github.com/matthew-ivancic/CloudResumeChallenge/blob/main/.github/workflows/terraform_apply.yml) will apply pending terraform state changes to infrastructure
