class Tfsec < Formula
  desc "Static analysis powered security scanner for your terraform code"
  homepage "https://github.com/tfsec/tfsec"
  url "https://github.com/tfsec/tfsec/archive/v0.38.6.tar.gz"
  sha256 "94e0919791431408b267bccb306b28f1e967ed744f3ab9f5c042cf267322a484"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c2d76a9d9e659e9fd82b180812c0d43b89f660758e1d4805d268063eea621e13"
    sha256 cellar: :any_skip_relocation, big_sur:       "07115c8b22a51af5b756fb16c07cb8e378e6a32dfd295a444e66f4adf81b2f29"
    sha256 cellar: :any_skip_relocation, catalina:      "c81446c95004f15ad87a0c7a756a00c7d4b29702959de792f8d6cac994071133"
    sha256 cellar: :any_skip_relocation, mojave:        "2fe5cfcca6719169343848c95f5a09695de0a5bbdad98068107ff5630f6ad623"
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
