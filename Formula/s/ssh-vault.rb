class SshVault < Formula
  desc "Encrypt/decrypt using SSH keys"
  homepage "https://ssh-vault.com/"
  url "https://github.com/ssh-vault/ssh-vault/archive/refs/tags/1.0.12.tar.gz"
  sha256 "ee05defead0a520c0273409aa8bf45980624dec2bd151dcb329a8939174f095f"
  license "BSD-3-Clause"
  head "https://github.com/ssh-vault/ssh-vault.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9f029e5609cdfa9b1c5f7779e4ac4ddd52c7d5e0a651ae98938a492e2544af99"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b56ef75a5c80292310b322059e2ec0c362536f7a27f2edc225e1b3950974c55f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf1cfcf9a97b36c604394c5ccaa8b838075dcbc8902366c790887851b9a0ed49"
    sha256 cellar: :any_skip_relocation, sonoma:         "87137792b61dd42391765dbeea12619ee9797a6a2c9e0679281885f84bed632f"
    sha256 cellar: :any_skip_relocation, ventura:        "6e90d4b8f249e3c0a5dcf2108cd1c3ad20a423c44f68850b776f62a61b73cb19"
    sha256 cellar: :any_skip_relocation, monterey:       "f1b6a0d4e7de78b56108b3cabdcd1c42ee84d6792968cf21c930797adfbb53e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "529a814177481fcbd643ee1cfd4de34a2b903feec7bcd54512ffa0dca9f18e7f"
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
