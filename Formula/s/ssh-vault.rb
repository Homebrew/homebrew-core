class SshVault < Formula
  desc "Encrypt/decrypt using SSH keys"
  homepage "https://ssh-vault.com/"
  url "https://github.com/ssh-vault/ssh-vault/archive/refs/tags/1.2.4.tar.gz"
  sha256 "444872970c6052ddede38fd4ef4707ee1b9660518379eee9afcb88468177ec1e"
  license "BSD-3-Clause"
  head "https://github.com/ssh-vault/ssh-vault.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af7845b06121a3fdba48b1cec89c2b31cb1bec69544da9a9803026ce82666410"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb4d760bf68edb6910bbeb928aceba2b912d410187d977fff49a404f9741739a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73b49582d8d7f88f28ba1f3aa89968c8745c5e72fdae92880c2538b9abf182e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "60d86263dc738f20ffd6f761f8da40a05c265d67196695e75ca1a1be67361282"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b787f8ec49473b2f4b18e395f7c00d1e2e7b4f56e57b649e1fbf84d555e1cc89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "773eff3ad8ad93a2ba1dc1f43230b4f91e120ad5364d79684c393e3e58387ed3"
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
