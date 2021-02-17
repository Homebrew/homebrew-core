class Tfsec < Formula
  desc "Static analysis powered security scanner for your terraform code"
  homepage "https://github.com/tfsec/tfsec"
  url "https://github.com/tfsec/tfsec/archive/v0.38.4.tar.gz"
  sha256 "791322da015a3f1e5741e3e06140c65a87e90564b6d36bee2a29207ab45628ef"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fe8aadf07f0ea655d29f982392b8d536eccb33266c894489e8ef2956c027fa05"
    sha256 cellar: :any_skip_relocation, big_sur:       "2e34d2d314582ddf66701d46a6bda27f51e1768924003d36e58e636a2c3f6a16"
    sha256 cellar: :any_skip_relocation, catalina:      "5ed2bc7a82ce4d598286758a51dbc44c03f3fedabee0171863f79f1df0c9241e"
    sha256 cellar: :any_skip_relocation, mojave:        "f59364a68f514483bfad882be75f0e4fd973defadf9142e1a323e25a0a2f0b87"
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
