class SshVault < Formula
  desc "Encrypt/decrypt using SSH keys"
  homepage "https://ssh-vault.com/"
  url "https://github.com/ssh-vault/ssh-vault/archive/refs/tags/1.2.14.tar.gz"
  sha256 "0a35f23e6e9d0db777306d961379f184305180efeec5a5d1fef4962cb4a87489"
  license "BSD-3-Clause"
  head "https://github.com/ssh-vault/ssh-vault.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f4436a86e034dee74b2e070900cb93c71f6488e1ef3248994e90de3810e48a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dbc973afa98ce266b91081b475566ad20cce0073f13b06a59f0f9b03d7f4e203"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7171a8f9ed8b3e6658ad3f2e48ecf9bbbcd20dab1e609f60ada6198808346939"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1150a1f4d9033a95cf9f5881baa6a33560a777ed4d3f50e83f9face5f0003fc"
    sha256 cellar: :any,                 arm64_linux:   "9b2c9b0d4cf4c4aece56aaa0f2fcbc3327163b0220522f5fec00c427667bf9d4"
    sha256 cellar: :any,                 x86_64_linux:  "1aac8c079f07be86b8fb995ac09de16d5e0cb47ec5f11b75b9f26f0f085e8f1e"
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
