class SshVault < Formula
  desc "Encrypt/decrypt using SSH keys"
  homepage "https://ssh-vault.com/"
  url "https://github.com/ssh-vault/ssh-vault/archive/refs/tags/1.2.2.tar.gz"
  sha256 "040aaadb85fad375388b836157bd2615081607d58dbcfc51d1af1e922a2d29c4"
  license "BSD-3-Clause"
  head "https://github.com/ssh-vault/ssh-vault.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "67019b55b41909e74e16677a447a2338250eab7ccf5e8b9dc6bd2d91be9c5e66"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b52cf67b21ab56d7665759322071f83b4dbc4bdc5c364de2a945b77007c24ad7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8dc2bc7cdb818bc80b7ffc9774e681fe597b43ca4430818df7a793200ed5216"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ad1ada372d9d159169ddddf6067f8b3d4b1b56c75a3727cd76b004b26c14108"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "248537ca22b938592ae89f4130ade2760e85c2d29b7a047ce275e39f6ccf46d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c94c0cc6d4adacfea2e4a75a51fef91bc50baf711b2f0bbde98d378fb1d7719"
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
