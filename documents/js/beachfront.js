
function getContactEmail() {
	return "VeniceGeo@digitalglobe.com";
}

window.onload = function () {
	var contactEmailAnchor = document.getElementById("contact_email");
	if (contactEmailAnchor) {
		if (contactEmailAnchor.tagName.toLowerCase() == 'a') {
			contactEmailAnchor.text = getContactEmail();
			contactEmailAnchor.href = 'mailto:'+getContactEmail();
		}
	}
}