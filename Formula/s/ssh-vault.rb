class SshVault < Formula
  desc "Encrypt/decrypt using SSH keys"
  homepage "https://ssh-vault.com/"
  url "https://github.com/ssh-vault/ssh-vault/archive/refs/tags/1.3.5.tar.gz"
  sha256 "4af818276fec8205babce8c0725c21661e8191d9e61c549ef4bcc90d8070e7a3"
  license "BSD-3-Clause"
  head "https://github.com/ssh-vault/ssh-vault.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6a6ca5bf377dc9094a81eca5c3d8427ab20fbaa0f373925e9ca9462d87015c06"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "824492df6458e67e91922788fd0cb24fe01a5eccb339e863f312883d3ac58540"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5ec7ade81352de731fe686d89b96d0215d122b966c3912b86fdd702bc9a123ba"
    sha256 cellar: :any,                 arm64_linux:       "ef5645ce6e6ead95c907f7cdd321bd29118dd7593f7723b3f116a6d2859f0084"
    sha256 cellar: :any,                 x86_64_linux:      "b24513b3d76ce4d77e17f9401589dd9d0bd7f464a314f93ae1f03d59d6e25e20"
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
