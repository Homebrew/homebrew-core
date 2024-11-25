class SshVault < Formula
  desc "Encrypt/decrypt using SSH keys"
  homepage "https://ssh-vault.com/"
  url "https://github.com/ssh-vault/ssh-vault/archive/refs/tags/1.0.14.tar.gz"
  sha256 "d7b678b73694f23f96833405693189e09a3577a8de0a3de774d636970d0e9ea9"
  license "BSD-3-Clause"
  head "https://github.com/ssh-vault/ssh-vault.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3ee108d59eb02a626c5054fd031c5d5731e840b08aa1321a06317c0a8cd8b9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "320ead45e8af50a17ed6f408d5993929259a67c3e559c1f165dad7e3aba7e945"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "77942f2f03a4abbd4ebf8c37a1b49052ce08189d35a11598bdaf68205ffb9916"
    sha256 cellar: :any_skip_relocation, sonoma:        "84b37f454c937c319be9c17a7864a965c536a82bcd3bf4f54f718f5a71f4d2e9"
    sha256 cellar: :any_skip_relocation, ventura:       "48d96be53c0be444e4f7c542597095966f57d6c85056e4abe8d575cb5e65af1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39a78207e70b5c7d52b43e70ef9437b84633eafcd179b0ca73a47254e3d62053"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
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
