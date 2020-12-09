class Tfsec < Formula
  desc "Static analysis powered security scanner for your terraform code"
  homepage "https://github.com/tfsec/tfsec"
  url "https://github.com/tfsec/tfsec/archive/v0.36.10.tar.gz"
  sha256 "9859f4764c2564639f1a11901af8add7d6215d1d3237811a28f85b85c2b6a091"
  license "MIT"

  livecheck do
    url "https://github.com/tfsec/tfsec/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "689e7df8b33ff0e6f9b67dfa2e16a9cd937ddcaf963a48d1d84ecb298be6acab" => :big_sur
    sha256 "32e62377f5fd98f9523830aa32ac3a594514e615d7c1eb595a46f6e33e7c0558" => :catalina
    sha256 "8c25e7b018cae3f5127726f2be7ff485894968bb1e712330c9c8e562b85d9667" => :mojave
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
