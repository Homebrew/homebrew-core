class SshVault < Formula
  desc "Encrypt/decrypt using SSH keys"
  homepage "https://ssh-vault.com/"
  url "https://github.com/ssh-vault/ssh-vault/archive/refs/tags/1.1.5.tar.gz"
  sha256 "73d73ec173400dafb290a237bb75a18e555b4216ee01be22a54c09ff2a51bebe"
  license "BSD-3-Clause"
  head "https://github.com/ssh-vault/ssh-vault.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80994e7d1ba41dbc10dd534a2c61afd68c347197a152455cf555bd3749d9a95b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1137e33677aebcbbe055176525f13a9c8b983a9acb46bcce45e2fc168635f42a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4154aa3dbfb51931115fc74b3447e35d2f1ce0b3989faa99cc0023cf7796d73a"
    sha256 cellar: :any_skip_relocation, sonoma:        "acc48c61601ead126bd7702aed108dfbdb4d6f4d405d9c818b9858677a5327fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a96e902a861e47277f298df4e4cf5ee63d31cac6d3265a5eda1e5f78a6302185"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb2b50f4ba9fd803b89ac50688d2643a00646c42f474bef76bb287e7549dd3cb"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    require "utils/linkage"

    test_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINixf2m2nj8TDeazbWuemUY8ZHNg7znA7hVPN8TJLr2W"
    (testpath/"public_key").write test_key
    cmd = "#{bin}/ssh-vault f -k  #{testpath}/public_key"
    assert_match "SHA256:hgIL5fEHz5zuOWY1CDlUuotdaUl4MvYG7vAgE4q4TzM", shell_output(cmd)

    if OS.linux?
      [
        Formula["openssl@3"].opt_lib/shared_library("libssl"),
        Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
      ].each do |library|
        assert Utils.binary_linked_to_library?(bin/"ssh-vault", library),
              "No linkage with #{library.basename}! Cargo is likely using a vendored version."
      end
    end
  end
end
