class SshVault < Formula
  desc "Encrypt/decrypt using SSH keys"
  homepage "https://ssh-vault.com/"
  url "https://github.com/ssh-vault/ssh-vault/archive/refs/tags/1.0.13.tar.gz"
  sha256 "38887f44b31094d164a767bb027813d8a958721bb4278373a255dc4c76ad5a27"
  license "BSD-3-Clause"
  head "https://github.com/ssh-vault/ssh-vault.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ebb093bd0d1774bf4d78f6799a6976501afca67b3c20f3a835eb43de8d711305"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8b3cf1073d31eddb1021c44a3abfdbcaba54039881f6af5b07db543b6bc9b4c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b5d72d5e7aa2a80d1606167afdebe617c59f720fc0f2eb87151111af1005608"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed47c467ec8f7bbff0d2c345028c305e5d7ae914aae376da0ccc835d9601af24"
    sha256 cellar: :any_skip_relocation, sonoma:         "6ef42de7d4be4691cdf0c30b7fce78c0ff1dfcd2de8b94fe638df8fc7e1d98ff"
    sha256 cellar: :any_skip_relocation, ventura:        "953cdf9819a345f2e0a99e2919c839b3c5a3b975cb92d0305abe22ec0951a231"
    sha256 cellar: :any_skip_relocation, monterey:       "65dc8174379e6262d6982be11508645dba4fb934b262644d46013688a9aac59c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97fed43c8a9f28b090935758d917783b09995d0e8c3bb76ca159a87988563506"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    test_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINixf2m2nj8TDeazbWuemUY8ZHNg7znA7hVPN8TJLr2W"
    (testpath/"public_key").write test_key
    cmd = "#{bin}/ssh-vault f -k  #{testpath}/public_key"
    assert_match "SHA256:hgIL5fEHz5zuOWY1CDlUuotdaUl4MvYG7vAgE4q4TzM", shell_output(cmd)

    if OS.linux?
      [
        Formula["openssl@3"].opt_lib/shared_library("libssl"),
        Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
      ].each do |library|
        assert check_binary_linkage(bin/"ssh-vault", library),
              "No linkage with #{library.basename}! Cargo is likely using a vendored version."
      end
    end
  end
end
