class SshVault < Formula
  desc "Encrypt/decrypt using SSH keys"
  homepage "https://ssh-vault.com/"
  url "https://github.com/ssh-vault/ssh-vault/archive/refs/tags/1.3.4.tar.gz"
  sha256 "6dc377accfcd06d50280511a5736d99eb495ddfac006d96ad8fde79f801d1c1a"
  license "BSD-3-Clause"
  head "https://github.com/ssh-vault/ssh-vault.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f65c587485165810c1fadf6eb440b57de6effd6f4a6ac825fb1ec274d330564"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9a1e0f8446fc26fd69ec216802cd124576d205cbd876349e609ed700df4bf48"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a6c2cf9a409f6420a754dbff908f27f6cd805df72781ad491c88142b1684e02"
    sha256 cellar: :any_skip_relocation, sonoma:        "03051b4af1ac48bf28858a5d272651ba361e73d6e846b4d0689f4bc0903b6b56"
    sha256 cellar: :any,                 arm64_linux:   "68f6f59a6271a883e1c1e2f5982ed15432bb23467dc58e3d9bf9ccc6a3006839"
    sha256 cellar: :any,                 x86_64_linux:  "013388faa924e8751c45f9bce1a02940a9858e9714d1ad56d9b34126b55801cf"
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
