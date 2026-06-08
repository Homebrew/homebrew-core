class SshVault < Formula
  desc "Encrypt/decrypt using SSH keys"
  homepage "https://ssh-vault.com/"
  url "https://github.com/ssh-vault/ssh-vault/archive/refs/tags/1.2.10.tar.gz"
  sha256 "c77f19bab7921128032dd874f58dd030555970a165342af73adef2e4d5b25938"
  license "BSD-3-Clause"
  head "https://github.com/ssh-vault/ssh-vault.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b9f47d2df517088e5c4cda4914ea208fae46f91da4aee5842c88577e1b192ff4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e707efedac951397eeaf41f2fec8430601494caa5602dcbf32842a15f1daca54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15139f93f196441eb293f651ea149e52fed901054dee38d31d3553070aa08f22"
    sha256 cellar: :any_skip_relocation, sonoma:        "99fd1c5ea72fd4571615d411f3e37cb3fff4b8c450dcdac11c2fe6d38d8cade7"
    sha256 cellar: :any,                 arm64_linux:   "347186b74d371b1d5882742cc92f27bb52e367238127f4bd594a31781f6e17b6"
    sha256 cellar: :any,                 x86_64_linux:  "3519f40ba209e8b0113e9778d7b27eb67882c417c5e3031290baf213c45a3339"
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
