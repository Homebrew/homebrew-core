class Terrascan < Formula
  desc "Detect compliance and security violations across Infrastructure as Code"
  homepage "https://www.accurics.com/products/terrascan/"
  url "https://github.com/accurics/terrascan/archive/v1.5.0.tar.gz"
  sha256 "e969960d9748e50125359097f5004c34ccf72e638dd06d10204a62468d57b260"
  license "Apache-2.0"
  head "https://github.com/accurics/terrascan.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "aea4fc921a9bc17806e65a39dacdd9547658eb961db1f1ef0ffef2983583b74a"
    sha256 cellar: :any_skip_relocation, big_sur:       "e17888a492ace8be4e980409ed5c1fbef37f0487c95aeb95a4c3b37d04dbaa8d"
    sha256 cellar: :any_skip_relocation, catalina:      "a00587f2b704c07f60cc87f1c177806998ed4019b1358866df18731095cf7dd0"
    sha256 cellar: :any_skip_relocation, mojave:        "9a6b700d6bb49bc1b95e31f2eadfedd37edb574ce2933e935a2ae902c9bf9b90"
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
      \tPolicies Validated  :\t158
      \tViolated Policies   :\t0
      \tLow                 :\t0
      \tMedium              :\t0
      \tHigh                :\t0
    EOS

    assert_match expected, shell_output("#{bin}/terrascan scan -f #{testpath}/ami.tf -t aws")

    assert_match "version: v#{version}", shell_output("#{bin}/terrascan version")
  end
end
