class SshVault < Formula
  desc "Encrypt/decrypt using SSH keys"
  homepage "https://ssh-vault.com/"
  url "https://github.com/ssh-vault/ssh-vault/archive/refs/tags/1.2.3.tar.gz"
  sha256 "9bf85c29e4998b8814261d9d06dabdbc673b7a237d1cd19e4dbd7cad729ec7b1"
  license "BSD-3-Clause"
  head "https://github.com/ssh-vault/ssh-vault.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1fdc22edc80a7dd7b3d37dd96a2f69d14146098242646d87b54d942536b596b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09e6a9158ac36b4e4e2201f46234684e5e717bca5eadca30fce3b39a6575ecbc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c4bcaa6aad928e4edc85fbf336081860f58016388a50d0088e18ed9c9305cc5"
    sha256 cellar: :any_skip_relocation, sonoma:        "3953142c5e9975f066087b80fe95b15e437d276a51019d7205a1f2c8b1bacc22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ec8c45272ec33ca255b58834e714f24ee418d72184c3d5f4f0354949e8408a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0de014b2c746514a03b2b77b44e7c651bca84f8d3f6f6cd46bf0e68e6f2aa73"
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
