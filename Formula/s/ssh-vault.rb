class SshVault < Formula
  desc "Encrypt/decrypt using SSH keys"
  homepage "https://ssh-vault.com/"
  url "https://github.com/ssh-vault/ssh-vault/archive/refs/tags/1.3.11.tar.gz"
  sha256 "7688b17f273e96f4f432046fadd4b4760b075de50537d3bfa76b338600ecc311"
  license "BSD-3-Clause"
  head "https://github.com/ssh-vault/ssh-vault.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    manifest_sha256 "3eb23cf409b57fd4534bd96244bdbefac1b89104fec21c6bd1d1bce3f1fcd713"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f49e24045d0c6e1427d137182273dd34629e9ef2c2ca70f55b81f20bf30abde5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e32e95958180ca82c9c5ca0ffc35222cadd2f7f1ff35cdaccd6c9d52dfcb469d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ad93673a81ca3bd999bfd02b68ec1a0d45525e292bb6d32d3121bafd22295009"
    sha256 cellar: :any,                 arm64_linux:       "b64717a634035b6b737a1e2c72169861c65c0865d1564114ff3f8f50900031c0"
    sha256 cellar: :any,                 x86_64_linux:      "93fd1a26ebe8b485186d1903f7faca814b664ed7af39694626d42bf39f55e93c"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    test_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINixf2m2nj8TDeazbWuemUY8ZHNg7znA7hVPN8TJLr2W"
    (testpath/"public_key").write test_key
    cmd = "#{bin}/ssh-vault f -k  #{testpath}/public_key"
    assert_match "SHA256:hgIL5fEHz5zuOWY1CDlUuotdaUl4MvYG7vAgE4q4TzM", shell_output(cmd)
  end
end
