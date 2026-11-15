class SshVault < Formula
  desc "Encrypt/decrypt using SSH keys"
  homepage "https://ssh-vault.com/"
  url "https://github.com/ssh-vault/ssh-vault/archive/refs/tags/1.3.9.tar.gz"
  sha256 "f12f2c3052f32338a6bb01a4bcc3e4f5d705322ac41d533e80ae8aea9a1d7598"
  license "BSD-3-Clause"
  head "https://github.com/ssh-vault/ssh-vault.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "48048fe8f28e624def37117b03ef27d0fc52ec192f2b017440beb49def886707"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "05a4dde969d03817468ef74bd6d4e60255c0de0c0cb9a5512402b02721124f1d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c14e723a5151dbb503edc72c9d691155dae9703334116e09bfcd3193fdb14a14"
    sha256 cellar: :any,                 arm64_linux:       "7db7078d2bd908236d5a82a02ff00e4b87cb3a23022595ebd37405547bb7c751"
    sha256 cellar: :any,                 x86_64_linux:      "e0a387cf0993416f60b2d7b0f0532c869ed484a47b0070babcb9efeaebe18287"
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
