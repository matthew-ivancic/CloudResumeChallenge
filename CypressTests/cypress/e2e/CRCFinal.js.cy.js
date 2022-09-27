describe ('CRC Viewcount API testing' , () => {
    it('verify request returns JSON', () => {
        cy.request('POST', 'https://a8h4km0nbk.execute-api.us-east-1.amazonaws.com/Production').its('headers').its('content-type').should('include', 'application/json')
    })
    it('verify request returns correct code - 200', () => {
        cy.request('POST', 'https://a8h4km0nbk.execute-api.us-east-1.amazonaws.com/Production').then((response) => {
            expect(response.status).to.equal(200)
        })
    })
    it('confirm returned body increments appropriately when POSTed to', () => {
        let visitors
        cy.request('POST', 'https://a8h4km0nbk.execute-api.us-east-1.amazonaws.com/Production').then((response) => {
            visitors = response.body
        })
        cy.request('POST', 'https://a8h4km0nbk.execute-api.us-east-1.amazonaws.com/Production').then((response) => {
            expect(Number(response.body))==(Number(visitors)+1)
        })
    })
})