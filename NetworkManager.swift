import Foundation
import Contacts

class NetworkManager {
    func syncContacts(contacts: [CNContact], completion: @escaping () -> Void) {
        guard let url = URL(string: "https://crm.zyonto.com/chart.php") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("multipart/form-data; boundary=Boundary", forHTTPHeaderField: "Content-Type")
        
        let boundary = "Boundary"
        
        // Créer le body multipart/form-data
        var body = ""
        body += "--\(boundary)\r\n"
        body += "Content-Disposition: form-data; name=\"task\"\r\n\r\n"
        body += "testcalllog\r\n"
        
        for contact in contacts {
            body += "--\(boundary)\r\n"
            body += "Content-Disposition: form-data; name=\"contacts[]\"\r\n\r\n"
            let contactString = """
            {
                "firstName": "\(contact.givenName)",
                "lastName": "\(contact.familyName)",
                "phoneNumbers": \(contact.phoneNumbers.map { $0.value.stringValue })
            }
            """
            body += "\(contactString)\r\n"
        }
        
        body += "--\(boundary)--\r\n"
        
        guard let httpBody = body.data(using: .utf8) else {
            print("Failed to encode body")
            return
        }
        
        request.httpBody = httpBody
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Failed to sync contacts: \(error)")
            } else if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if json["status"] as? String == "ok" {
                            print("Contacts synced successfully.")
                        } else {
                            print("Failed to sync contacts. Response: \(json)")
                        }
                    }
                } catch {
                    print("Failed to parse response: \(error)")
                }
            }
            completion()
        }
        
        task.resume()
    }
}

