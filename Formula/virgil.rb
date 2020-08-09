class Virgil < Formula
  desc "CLI tool to manage your Virgil account and applications"
  homepage "https://github.com/VirgilSecurity/virgil-cli"
  url "https://github.com/VirgilSecurity/virgil-cli.git",
     tag:      "v5.2.6",
     revision: "5b1f02259660a71f7bcfea6567ef44cb2651a34a"
  license "BSD-3-Clause"
  head "https://github.com/VirgilSecurity/virgil-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "660c5390a198f3dd6848374d907281cd8026c7aff5a6ec7cae85267b07b941ae" => :catalina
    sha256 "4cb7ef9ff96d2dc1c848563f421c1a24c22435431bc7467946a945a819e3638e" => :mojave
    sha256 "2b79544d53288dc228a59c5c66bc7ea4dd58f23987a5a27bb893a191a3370559" => :high_sierra
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
