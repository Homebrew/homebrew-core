class Tfsec < Formula
  desc "Static analysis powered security scanner for your terraform code"
  homepage "https://github.com/tfsec/tfsec"
  url "https://github.com/tfsec/tfsec/archive/v0.35.0.tar.gz"
  sha256 "6899321da99ffc5595db6d33718edb03190024cf94f970e9df2e8975ced38889"
  license "MIT"

  livecheck do
    url "https://github.com/tfsec/tfsec/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "3a42c08f8e6ab3cc4548af07e1718cf947288db095c5d8267502469d4611affd" => :catalina
    sha256 "49dcc29ee9465a2ae68ca1f77ad4079f3a59e6f55ccf4781839e35b20d669ae2" => :mojave
    sha256 "740004004f83618c1bae0e8b35cb870a6eb61c4718fc09b8f3e1202b90901bbc" => :high_sierra
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
