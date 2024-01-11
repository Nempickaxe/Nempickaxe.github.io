const CONTACT_US_URL = process.env.CONTACT_US_URL

function submitForm() {
    // Get form values
    var name = document.getElementById('name').value;
    var email = document.getElementById('email').value;
    var message = document.getElementById('message').value;

    // Create form data object
    var formData = {
        name: name,
        email: email,
        message: message
    };

    // Send POST request to Google Sheets API
    fetch(CONTACT_US_URL, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify(formData),
    })
    .then(response => response.text())
    .then(data => {
        console.log(data);
        // Handle success, if needed
    })
    .catch((error) => {
        console.error('Error:', error);
        // Handle error, if needed
    });
}