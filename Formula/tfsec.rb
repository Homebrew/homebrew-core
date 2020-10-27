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
    sha256 "cebc5b9df622347bc3720a3663b492a1afc48b2d0102af36f68209b792eef860" => :catalina
    sha256 "9af34f701b0008e5bea1cbfd6c81de5cf07b4f163f687dac4a9c5b6bc4a98498" => :mojave
    sha256 "440e48205344914e24701f3b1851d2045d5db29bb472d2c05facb71435b6e1eb" => :high_sierra
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
