import SwiftUI

struct RegisterView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var username = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var name = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("账号信息")) {
                    TextField("用户名", text: $username)
                        .autocapitalization(.none)
                        .textInputAutocapitalization(.never)
                    SecureField("密码", text: $password)
                    SecureField("确认密码", text: $confirmPassword)
                }
                
                Section(header: Text("个人信息")) {
                    TextField("昵称", text: $name)
                }
                
                if let error = authViewModel.error {
                    Section {
                        Text(error.localizedDescription)
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("注册")
            .navigationBarItems(
                leading: Button("取消") { dismiss() },
                trailing: Button("注册") {
                    Task {
                        await authViewModel.register(
                            username: username,
                            password: password,
                            name: name
                        )
                        if authViewModel.isAuthenticated {
                            dismiss()
                        }
                    }
                }
                .disabled(!isValid)
            )
            .overlay {
                if authViewModel.isLoading {
                    ProgressView()
                }
            }
        }
    }
    
    private var isValid: Bool {
        !username.isEmpty &&
        !password.isEmpty &&
        password == confirmPassword &&
        !name.isEmpty
    }
} 