class Virgil < Formula
  desc "CLI tool to manage your Virgil account and applications"
  homepage "https://github.com/VirgilSecurity/virgil-cli"
  url "https://github.com/VirgilSecurity/virgil-cli.git",
     :tag      => "v5.2.4",
     :revision => "46ad6eba489482a5eaff5ba89424f822525a6063"
  head "https://github.com/VirgilSecurity/virgil-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "67c790483db72b2771c097dce90c5e937f7f5095821afba455b1708c798fedaf" => :catalina
    sha256 "efc28f3cd0fe03f72646c069442a44b3b17e785dfbc2a4c5018f922303f74ed1" => :mojave
    sha256 "ab03a53e7f602341811f1ce6af9ff6b41ccf84ca879f59916fe4f59ff3baca64" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make"
    bin.install "virgil"
  end

  test do
    result = shell_output "#{bin}/virgil purekit keygen"
    assert_match /SK.1./, result
  end
end
