class SshVault < Formula
  desc "Encrypt/decrypt using SSH keys"
  homepage "https://ssh-vault.com/"
  url "https://github.com/ssh-vault/ssh-vault/archive/refs/tags/1.0.10.tar.gz"
  sha256 "0e29daebb65422c4909c84dba126292c6e3d88933822b2a02e4ff1627da9dc3e"
  license "BSD-3-Clause"
  head "https://github.com/ssh-vault/ssh-vault.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f4a2349338d9a035c924392a168ec26ec4d2f1a1f79276d7694dd3f0f25d6d2e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f8056714240bc5d1d34c148666505739987a28df806a5504bc55455720d0b143"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18933ad16a7bb6518cae23c3bc647193818b52527c37d469cf760235b08b43fe"
    sha256 cellar: :any_skip_relocation, sonoma:         "a63eadaf3d9fb5af2c6236fb2b3b85b449b89e65672a5a264bc7e7230ff78760"
    sha256 cellar: :any_skip_relocation, ventura:        "140042c2c1f6d2e299e2fe1dfa60a1a91d0e8b6a07248affbd9a364557a7f054"
    sha256 cellar: :any_skip_relocation, monterey:       "4886bba2186ba3a628a6137cdcdc40705d7f48492baa47073f4c321b0dcb3928"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28be2ede3671520d5fb33c248c9dad6bc0f136ccb854e0080ea8e8025b1b6957"
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
