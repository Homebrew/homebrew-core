class Tfsec < Formula
  desc "Static analysis powered security scanner for your terraform code"
  homepage "https://github.com/tfsec/tfsec"
  url "https://github.com/tfsec/tfsec/archive/v0.31.0.tar.gz"
  sha256 "4cf8194d1aabf7207f9873ef10bd7e9b271eaeed503a0d71c03719cd5126dbe1"
  license "MIT"

  livecheck do
    url "https://github.com/tfsec/tfsec/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "adb26b3a24ec2ca6e4ab184ff6bf972005ae1276a5f036f4279126de0edd5d86" => :catalina
    sha256 "047589b24dade9ef8742887c0f5fb16359eec3beb4458858c02ecbca0aa9d4fc" => :mojave
    sha256 "6372b136027e5796aafe197da45bc78d76b22629cde660f84ffd2a1b0bd0097d" => :high_sierra
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
