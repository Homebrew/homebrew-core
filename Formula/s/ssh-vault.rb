class SshVault < Formula
  desc "Encrypt/decrypt using SSH keys"
  homepage "https://ssh-vault.com/"
  url "https://github.com/ssh-vault/ssh-vault/archive/refs/tags/1.3.2.tar.gz"
  sha256 "9dc3ec27b6183d4c172c0a87e17a2ee4d0ed580e01b6b56518ec820b4c71c697"
  license "BSD-3-Clause"
  head "https://github.com/ssh-vault/ssh-vault.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb635c53fdf90be7d5fb6b6ae7db5385aa7244698118b25edff79b267d0c5ed7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea52b9425fed63bff1770edb62e28ac4fc397db548f84893c1be4f8b9f20556a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d0bf060e6edcebdcef82d8fd32ddf864ca78e585d0f7bb91c6897cadd65e948"
    sha256 cellar: :any_skip_relocation, sonoma:        "85afda7d0f39cd284b8aaba817aaa167cd63bc20dca561ed4b3a578a2936fd6c"
    sha256 cellar: :any,                 arm64_linux:   "98e48526262f14da2162cc77b22a372982989ee4ad4bab44b0f2193ac4dade57"
    sha256 cellar: :any,                 x86_64_linux:  "1e8b97a9261f6f02402e2a73414003fd0037dc6d325ef4bfd5a6400aaad9a6eb"
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
