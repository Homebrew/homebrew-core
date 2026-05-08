class SshVault < Formula
  desc "Encrypt/decrypt using SSH keys"
  homepage "https://ssh-vault.com/"
  url "https://github.com/ssh-vault/ssh-vault/archive/refs/tags/1.2.8.tar.gz"
  sha256 "43297041890cd9381b430566c800394099a0613e5258307bd396b6cb4da1cf7a"
  license "BSD-3-Clause"
  head "https://github.com/ssh-vault/ssh-vault.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c3103411de13b2cd2883ff578d192766929c17a55c11d6b29b9b2a226ec210b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee94d3fb9cc46db492993b10d2e42284091c783bd303e5f533d710c77b101341"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9aa70b1a9d7a79371f80a78571f1ea0307a4d5cc9a1f7c4d83a8d137df8e7d4b"
    sha256 cellar: :any_skip_relocation, sonoma:        "53c82860e6eebc01367860c316573e9296d70e36dfaeb75cb63d38c2ac98f9ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "591c094dc942582aa4379ba6b1bdfcfb962cb0dd01cafde1569d5065e7c76c04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8df711571ae10a312b52b8805abbc0915e70ccff850d38abfc43b80bda63d44"
  end

  depends_on "rust" => :build

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
