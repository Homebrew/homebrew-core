class SshVault < Formula
  desc "Encrypt/decrypt using SSH keys"
  homepage "https://ssh-vault.com/"
  url "https://github.com/ssh-vault/ssh-vault/archive/refs/tags/1.2.5.tar.gz"
  sha256 "14e3015e1cf52e64751f8574bde18058f1b964b36ae5475db7763b86f14e4d96"
  license "BSD-3-Clause"
  head "https://github.com/ssh-vault/ssh-vault.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d1a7affb8673dcb792b7c5bc87f1f9864e50da02e6337f8eff8024eb098caf7d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37da52524152ee75bdaaf9635938d9fda7e691b177feb1c0ec3b7788dcf28173"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5006291b13f31e6f81f667e173f9e62932cd4787d656e33da2e3d2eb41f6cea7"
    sha256 cellar: :any_skip_relocation, sonoma:        "25bf75240d6765b959db67ae7c2255d85970e34b8dfd25150ac8c0a7773d12bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f619b51e88d5343494628e1101e7ec400eb998615baaa597030f7e8cb1efbd76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5b5369ffa31eec116de95a463c4af4e12949a0d5a5a7a893194c7941cc19633"
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
