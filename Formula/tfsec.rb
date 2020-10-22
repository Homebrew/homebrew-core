class Tfsec < Formula
  desc "Static analysis powered security scanner for your terraform code"
  homepage "https://github.com/tfsec/tfsec"
  url "https://github.com/tfsec/tfsec/archive/v0.31.0.tar.gz"
  sha256 "4cf8194d1aabf7207f9873ef10bd7e9b271eaeed503a0d71c03719cd5126dbe1"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "c690a49f89af1a4adcfec4d4efc804b64113f4c4ef826af828349eeeadf10ce4" => :catalina
    sha256 "bd6c1ad822401704511bb4141bd2b7435e4bb571d4d191fcc16dc4b35e0a085d" => :mojave
    sha256 "e625749b036d7cff56090b1138ce19eabcc70888ce405ea52f193f08a0575794" => :high_sierra
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
