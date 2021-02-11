class Tfsec < Formula
  desc "Static analysis powered security scanner for your terraform code"
  homepage "https://github.com/tfsec/tfsec"
  url "https://github.com/tfsec/tfsec/archive/v0.38.1.tar.gz"
  sha256 "c29a901a0c5213945223bbf98122f8bac9294aa3575263ea809a6014cf685bd4"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1643c0006207353356c24e937041be40509ef86e8582ae4efaa2e57bd4637a5b"
    sha256 cellar: :any_skip_relocation, big_sur:       "e2473c1206894a43607b0f44e1d2ea8a2f1653498d004fe96b7826670075ad3e"
    sha256 cellar: :any_skip_relocation, catalina:      "50fed7bda9757aaa20069eda9a4c7139e6387fc9a8ed6f81b6b1a28c9b68a75f"
    sha256 cellar: :any_skip_relocation, mojave:        "85b965c1714c3ae67517d1eb497e6b1799c3f16653c63d8d16243786735b8592"
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
