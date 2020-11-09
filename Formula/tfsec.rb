class Tfsec < Formula
  desc "Static analysis powered security scanner for your terraform code"
  homepage "https://github.com/tfsec/tfsec"
  url "https://github.com/tfsec/tfsec/archive/v0.36.3.tar.gz"
  sha256 "61f03f6501aca407d8e3dbdef606f989339c03c4f57f931a1530ed18481470d8"
  license "MIT"

  livecheck do
    url "https://github.com/tfsec/tfsec/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "33c7d108580ccb3682c5fa1d349c144245d3d66f6c6a306c7710738dcb001a22" => :catalina
    sha256 "a0125a8923bde41532d3d61ab6ea4255da6a77f5361145014c89cea1eaae9162" => :mojave
    sha256 "ce1a31697566680b2fb1f24031f2766d9c8a6fc99dec45d9d6f436d987ecebdf" => :high_sierra
  end

  depends_on "go" => :build

  resource "testfile" do
    url "https://raw.githubusercontent.com/tfsec/tfsec/2d9b76a/example/brew-validate.tf"
    sha256 "3ef5c46e81e9f0b42578fd8ddce959145cd043f87fd621a12140e99681f1128a"
  end

  def install
    system "scripts/install.sh", "v#{version}"
    bin.install "tfsec"
  end

  test do
    resource("testfile").stage do
      assert_match "No problems detected!", shell_output("#{bin}/tfsec .")
    end
  end
end
