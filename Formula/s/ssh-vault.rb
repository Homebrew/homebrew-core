class SshVault < Formula
  desc "Encrypt/decrypt using SSH keys"
  homepage "https://ssh-vault.com/"
  url "https://github.com/ssh-vault/ssh-vault/archive/refs/tags/1.1.2.tar.gz"
  sha256 "02315986e9e968dee14a55acec196b3f86375f39bbebf9a78486f77f156b21f6"
  license "BSD-3-Clause"
  head "https://github.com/ssh-vault/ssh-vault.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3f76477017b8a045f5c6c89f58ea584fcca6c07829c6f4960b0824e75bcb99e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8bdbc585cc4e75dcfb0be8efc37c9eabb87964f220961be444444ca500d42f4f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3766d486d27843ffdccc43ba4d32c8d6d3c4cc684d7654578bfc921c094f0e2f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a1a9fb86c8ee338853f2dd6734f656bc0133c7f0a95aa4f4967a005da52ea853"
    sha256 cellar: :any_skip_relocation, sonoma:        "7516171015d6bba24398c5756b5d59aad31186e6ea1cf8c002c61952f3df9410"
    sha256 cellar: :any_skip_relocation, ventura:       "3a33eb086a7d96418da079a4cedfa6f2aefbb72d57a4013d988a0f20d146ba3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0093534c4398d3903258962fd3358a5a6afb42018ed53381f6a1a1a361050c10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ada1d0112d7b31e1b36acccbcd60722733d786a5389095c5da8c173b21dc0438"
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
