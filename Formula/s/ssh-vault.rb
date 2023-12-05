class SshVault < Formula
  desc "Encrypt/decrypt using SSH keys"
  homepage "https://ssh-vault.com/"
  url "https://github.com/ssh-vault/ssh-vault/archive/refs/tags/1.0.8.tar.gz"
  sha256 "6fd7c5fce2687b6a1f18c829aac0475cdada0398a99364a87469fc2736c44e8c"
  license "BSD-3-Clause"
  head "https://github.com/ssh-vault/ssh-vault.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7cf25bb31704c276452df11a45a94bb25bc2698e0b102fc17d85ca7650fbc295"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "426a3665b0c52c07f67ee7b2878dc61a7657a70b7871473fff881cc22fd222e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9aa2104012940e3775cdbcd9d4d127dfa0b3112ccdd936e5b03e985d8e63f57b"
    sha256 cellar: :any_skip_relocation, sonoma:         "232e44a67dd7513c9b6911d57052e82be5c9e7d9c837eabc65db485979bfc304"
    sha256 cellar: :any_skip_relocation, ventura:        "58ff80d0f4acc7cbe04361b9e07699741cef2d0cbcd4a4407b5376fc391630b2"
    sha256 cellar: :any_skip_relocation, monterey:       "e021fca12caafa731a5188a8bc4154d2e55f2d7b183626017394313300e157a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8a00ed928867df777aefa4ca8953b39e54ced9f5eea92592af01ce63a1c3e31"
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
