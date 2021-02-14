class Tfsec < Formula
  desc "Static analysis powered security scanner for your terraform code"
  homepage "https://github.com/tfsec/tfsec"
  url "https://github.com/tfsec/tfsec/archive/v0.38.3.tar.gz"
  sha256 "e4bbeb6506f9f3910f461198b95041c3146556338493871df053df2bba3d2e1a"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "845b1196f6e33d92a5c612e1196b7c412b62b3e84df57a5087dea54efdd73e29"
    sha256 cellar: :any_skip_relocation, big_sur:       "67005624ddbfd96a17fa06ac59880165bf4f9a64c8e3fb304dda08f28b931981"
    sha256 cellar: :any_skip_relocation, catalina:      "25096db2ad61ac278b47c3ffc828ab54140ac4811bb33f2d661da88adaa4d544"
    sha256 cellar: :any_skip_relocation, mojave:        "499493dc5e5503f7658c810a48051ab7d54c81e418a222fd613d1033000aaae8"
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
