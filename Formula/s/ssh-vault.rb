class SshVault < Formula
  desc "Encrypt/decrypt using SSH keys"
  homepage "https://ssh-vault.com/"
  url "https://github.com/ssh-vault/ssh-vault/archive/refs/tags/1.2.7.tar.gz"
  sha256 "57423072835d09d43062f8ae328dc9ee76cb13d7efcc62a02ffd3b9f77a08ed7"
  license "BSD-3-Clause"
  head "https://github.com/ssh-vault/ssh-vault.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "03502b75c1b91d20cc3dac39d3c220334fb6d2685d931da25698e2ffdfa4ef84"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a1b59db16e7452560a3e91b9afdece4f8cc50b1881e1dae2098979889117998"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef7bbfa0641ad2e07a49c17147f706fc5cded90006dfbbf05ef26cd85674d314"
    sha256 cellar: :any_skip_relocation, sonoma:        "98ddc49b6af76583481b0c85355d323f5850deb616c38b66b794c212df75ffaf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b45d28af83c0479c0da86798690ac41e36a028713ae7c6a2cb4b504103905e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "504996d1c117e3d212f38bf521ad0963ea995cb1e88606acd740c3b865c3fd20"
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
