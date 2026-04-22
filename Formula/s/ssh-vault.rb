class SshVault < Formula
  desc "Encrypt/decrypt using SSH keys"
  homepage "https://ssh-vault.com/"
  url "https://github.com/ssh-vault/ssh-vault/archive/refs/tags/1.2.6.tar.gz"
  sha256 "09b335c6afac984a1a7e5a5d7910728a1beee65cb2fe27545fc923594d0b4b9c"
  license "BSD-3-Clause"
  head "https://github.com/ssh-vault/ssh-vault.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df669e1d5d43636895f55c81c004bfc555f2e6dee82bc63a594740af1f085942"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "154df103306cfc938ea5b0fb1de6336ad6a77fac52a6da22a392129c6dcdaa74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "120b99b614b6d5511edcfdea43f0c0ba1010e8b49a6527e063167c62328cd1fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "353ec9425b34589fb0d1e3bf1a7329bdcfdeb3815d39cff1b913f0968be3c7a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe1feb35a10d0bc90a093e324991ebe89b5a1ec993c23c48990bf05fd84cc6d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5a2fcd6b3afda6561ca904f107d5f726219e4b1d3b0212755bc637d29bc98fb"
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
