class Terrascan < Formula
  desc "Detect compliance and security violations across Infrastructure as Code"
  homepage "https://www.accurics.com/products/terrascan/"
  url "https://github.com/accurics/terrascan/archive/v1.1.0.tar.gz"
  sha256 "4ebca4331c69fb4e11ffbe2699e19ba4354d51b597cbad5188dd39331230f8cb"
  license "Apache-2.0"
  head "https://github.com/accurics/terrascan.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "251437fab5c965b052488e3e938a5801aed88099c7624e47b98aa238b2d90a29" => :catalina
    sha256 "070e5251c01b77974afb44fa01f55aa4a7cb14063bead5885456327bd86d07a9" => :mojave
    sha256 "1c26c19e0b247860b55b1998b1ecb8d0009190eadc45031fa943604a03ef63ed" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/terrascan"
  end

  test do
    (testpath/"ami.tf").write <<~EOS
      resource "aws_ami" "example" {
        name                = "terraform-example"
        virtualization_type = "hvm"
        root_device_name    = "/dev/xvda"

        ebs_block_device {
          device_name = "/dev/xvda"
          snapshot_id = "snap-xxxxxxxx"
          volume_size = 8
        }
      }
    EOS

    expected = <<~EOS
      results:
        violations: []
        count:
          low: 0
          medium: 0
          high: 0
          total: 0
    EOS

    assert_match expected, shell_output("#{bin}/terrascan scan -f ami.tf -t aws")

    assert_match "version: v#{version}", shell_output("#{bin}/terrascan version")
  end
end
