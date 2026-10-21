class SshVault < Formula
  desc "Encrypt/decrypt using SSH keys"
  homepage "https://ssh-vault.com/"
  url "https://github.com/ssh-vault/ssh-vault/archive/refs/tags/1.3.7.tar.gz"
  sha256 "73c8f676e4e8ed4e3b8dec236715093fc934d3fa5f9ab9eeb535125f1dbe26f0"
  license "BSD-3-Clause"
  head "https://github.com/ssh-vault/ssh-vault.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5fafc678ff749e4f449b4a6cbd86588ae26f6551be3e2301203bb3a6a0b1a910"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d1b84bd48324a87564ae524089c8250b780410db968f66dcacbb255249383038"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2939e84696258aa543c37bdc30513462f246810c00c185ac6607059d122dbd1b"
    sha256 cellar: :any,                 arm64_linux:       "415ebc6c89a28c0108717f3a3154fff1a7ae9ad619e95d2f71ca6b00eed1d75d"
    sha256 cellar: :any,                 x86_64_linux:      "e579a58b82aa15f71fb398cb192c61a620891e8e76413999b4597e59a8cb5d51"
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
