import Foundation
import Supabase

class SupabaseService {
    static let shared = SupabaseService()
    
    let client: SupabaseClient
    
    private init() {
        // TODO: Move these to a secure configuration file or environment variable in production
        let supabaseUrl = URL(string: "https://zuhuvjuenylooptyhcyf.supabase.co")!
        let supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inp1aHV2anVlbnlsb29wdHloY3lmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQ5Mzg2MjMsImV4cCI6MjA4MDUxNDYyM30.qvLHOj8pmKfPCMfDKK2PQTjBIozxzXgXRtOropliQw8"
        
        self.client = SupabaseClient(
            supabaseURL: supabaseUrl,
            supabaseKey: supabaseKey,
            options: SupabaseClientOptions(
                // auth: .init(emitLocalSessionAsInitialSession: false) // Default is false
            )
        )
    }
}
