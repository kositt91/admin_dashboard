Row(
            children: [
              Center(
                child: Container(
                  height: 600,
                  width: 480,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/login.png'))),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo
                      Container(
                        height: 105,
                        width: 222,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                'assets/images/logo.png'), // Replace with your logo image path
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Container(
                        child: Text("管理画面ログイン"),
                      ),
                      SizedBox(height: 20),

                      // Username title
                      Container(
                        alignment: Alignment.centerLeft,
                        width: 350,
                        child: Text(
                          'ユーザーネーム',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      // Username field
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 24.0, right: 24.0, top: 8),
                        child: Container(
                          width: 350,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Color.fromARGB(
                                    255, 182, 180, 180)), // Add border
                            borderRadius: BorderRadius.circular(
                                8), // Optional: Add border radius
                          ),
                          child: TextFormField(
                            controller: _emailController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your username';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.people_alt,
                                color: Colors.grey,
                              ),
                              border: InputBorder.none, // Remove default border
                              hintText: 'ユーザーネーム',
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // Password title
                      Container(
                        width: 350,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'パスワード',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      // Password field with border
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 24.0, right: 24.0, top: 8),
                        child: Container(
                          width: 350,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Color.fromARGB(
                                    255, 182, 180, 180)), // Add border
                            borderRadius: BorderRadius.circular(
                                8), // Optional: Add border radius
                          ),
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.grey,
                              ),
                              border: InputBorder.none, // Remove default border
                              hintText: 'パスワード',
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                            ),
                          ),
                        ),
                      ),

                      // Forget password
                      Padding(
                        padding: const EdgeInsets.only(top: 34),
                        child: InkWell(
                          onTap: () {
                            // Navigate to the Forgot Password screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ForgotPasswordScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'パスワードを忘れた場合',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              color: Color.fromARGB(255, 25, 7, 139),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                        width: 360,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 35.0),
                          child: ElevatedButton(
                            onPressed: _loading ? null : _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 40, 41, 131),
                              padding: const EdgeInsets.only(
                                top: 20,
                                bottom: 20,
                              ),
                            ),
                            child: _loading
                                ? CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  )
                                : const Text(
                                    'ログイン',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),