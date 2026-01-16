class SshVault < Formula
  desc "Encrypt/decrypt using SSH keys"
  homepage "https://ssh-vault.com/"
  url "https://github.com/ssh-vault/ssh-vault/archive/refs/tags/1.2.1.tar.gz"
  sha256 "e5bb2e0374775ed6229501d2b0c9e84f42a0ed7fceb0af8ab21778846924aa38"
  license "BSD-3-Clause"
  head "https://github.com/ssh-vault/ssh-vault.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d090a2d54fa96e2aebb8c3d578ba0ad0842e0e3483d408adb3898adbf64e2ba2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b70350d78351da68cd1ac7d256db2dcad927357094a09dd8674b053b6e54c2b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a8eab08204813d8f1fd9e94cb08de370e29b78d8382f191b4ccd74b7dbb838f"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd4692d34616626f9618d1c4d8179238a6e3602d7839fb6e898d2097a0b76272"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af4505ed92842d4ea3358b6179b60024e6e6eccb449727493d13cf77831c60d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21c45413ce053c1d88cc904ccae5e65136fa26c76290b590efeb5704184728fd"
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
