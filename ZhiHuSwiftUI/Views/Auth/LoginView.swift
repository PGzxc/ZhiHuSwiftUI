import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel
    @State private var username = ""
    @State private var password = ""
    @State private var showingRegister = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 100))
                    .foregroundColor(.blue)
                
                TextField("用户名", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .textInputAutocapitalization(.never)
                
                SecureField("密码", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                if authViewModel.isLoading {
                    ProgressView()
                } else {
                    Button("登录") {
                        Task {
                            await authViewModel.login(username: username, password: password)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(username.isEmpty || password.isEmpty)
                }
                
                if let error = authViewModel.error {
                    Text(error.localizedDescription)
                        .foregroundColor(.red)
                }
                
                Button("还没有账号？立即注册") {
                    showingRegister = true
                }
            }
            .padding()
            .navigationTitle("登录")
        }
        .sheet(isPresented: $showingRegister) {
            RegisterView()
        }
    }
} 