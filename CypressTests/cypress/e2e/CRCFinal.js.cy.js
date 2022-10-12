describe ('CRC Viewcount API testing' , () => {
    it('verify request returns JSON', () => {
        cy.request('POST', 'https://u2l16jlkki.execute-api.us-east-2.amazonaws.com/prod/CloudResumeChallenge').its('headers').its('content-type').should('include', 'application/json')
    })
    it('verify request returns correct code - 200', () => {
        cy.request('POST', 'https://u2l16jlkki.execute-api.us-east-2.amazonaws.com/prod/CloudResumeChallenge').then((response) => {
            expect(response.status).to.equal(200)
        })
    })
    it('confirm returned body increments appropriately when POSTed to', () => {
        let visitors
        cy.request('POST', 'https://u2l16jlkki.execute-api.us-east-2.amazonaws.com/prod/CloudResumeChallenge').then((response) => {
            visitors = response.body
        })
        cy.request('POST', 'https://u2l16jlkki.execute-api.us-east-2.amazonaws.com/prod/CloudResumeChallenge').then((response) => {
            expect(Number(response.body))==(Number(visitors)+1)
        })
    })
})
