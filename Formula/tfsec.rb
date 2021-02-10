class Tfsec < Formula
  desc "Static analysis powered security scanner for your terraform code"
  homepage "https://github.com/tfsec/tfsec"
  url "https://github.com/tfsec/tfsec/archive/v0.38.0.tar.gz"
  sha256 "a5fbc76a766afa67b8fc49c5c5cc2670c1a60e8dae78dc44337f13d62ee67584"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "521862e32e40c4f607593837b8d1c70f24f30ec735ebc0e5c63de158827503af"
    sha256 cellar: :any_skip_relocation, big_sur:       "862ca3dbd15be8d7d491ace960ab763f8d7efc57dfd60e19dd753f063a26e617"
    sha256 cellar: :any_skip_relocation, catalina:      "9b55abc68caf9a6098ed3d6b1ebc74bdd769984aef446ca6d120b8180cae75e6"
    sha256 cellar: :any_skip_relocation, mojave:        "cc7488e7ec2dc021a2621d91094f6c8cccb0ef50c9db73bc7b98d540db7942c7"
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
