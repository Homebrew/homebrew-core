class SshVault < Formula
  desc "Encrypt/decrypt using SSH keys"
  homepage "https://ssh-vault.com/"
  url "https://github.com/ssh-vault/ssh-vault/archive/refs/tags/1.3.1.tar.gz"
  sha256 "eec50b7198fd75a22d9fe35c5f66eb72530ca08085034a06dbd30929a266f094"
  license "BSD-3-Clause"
  head "https://github.com/ssh-vault/ssh-vault.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0333635284b087910480dede52d8db55c29003f2a3e29b913d75bbeb2b7c0471"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba98917e349a2ea1cb6f71007e52047b344b94421c177b7eccf06eb4cc36276e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95c45932d3f988c27690a5e0c17a344b93116f4acf11b0a9c6f3f9547b42af99"
    sha256 cellar: :any_skip_relocation, sonoma:        "7fc51e6bd323fccb494623ea7b08aad992c907d4188603288b0204c5d2ae6f5e"
    sha256 cellar: :any,                 arm64_linux:   "4184a76f812606131aa37d7656f006d938e84f353776a2afead4a6277d8962be"
    sha256 cellar: :any,                 x86_64_linux:  "120fb7232c35039a26adcd44018210bf919ac76d8b7558c09d42b7f212a253ab"
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
