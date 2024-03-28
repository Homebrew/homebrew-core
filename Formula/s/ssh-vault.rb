class SshVault < Formula
  desc "Encrypt/decrypt using SSH keys"
  homepage "https://ssh-vault.com/"
  url "https://github.com/ssh-vault/ssh-vault/archive/refs/tags/1.0.11.tar.gz"
  sha256 "ef124bdec41ec9236cbc815f5f9199d2746f270d3f87da73304937d4b389163c"
  license "BSD-3-Clause"
  head "https://github.com/ssh-vault/ssh-vault.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cdd501da3abe69472681d7aa4f89db6335fc86f969d8938a9cb98dd96270e53e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4b8597ddc151475f55ad768dac0a368e79ad600e55b8d57ece19c12488ab2410"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3a10b26907e7763d73eb738caf0467e19d90a3834c70b4bbfdac8c0a4e3bb67"
    sha256 cellar: :any_skip_relocation, sonoma:         "7654f549587bb6c3c630af30650a2d67cea56a95a54282e40b26fccf9eec855a"
    sha256 cellar: :any_skip_relocation, ventura:        "83106665ce1c105ed365be314a64db2841d4ea47c7319414cb3b14f693ab8406"
    sha256 cellar: :any_skip_relocation, monterey:       "eee1b04a058cb602e656b88a4f3175e5ec136bb59d384e6400c9295af96225eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44d39bd9eac0baed2f87414b3f7847fdeea6d41696001bbe98e8bb8d7a734484"
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
