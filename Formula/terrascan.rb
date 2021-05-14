class Terrascan < Formula
  desc "Detect compliance and security violations across Infrastructure as Code"
  homepage "https://www.accurics.com/products/terrascan/"
  url "https://github.com/accurics/terrascan/archive/v1.6.0.tar.gz"
  sha256 "4ff014832f5d4e85ee275930639705a8ad9123eb4691591e6645fc76f1b0eb95"
  license "Apache-2.0"
  head "https://github.com/accurics/terrascan.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "420232aa61cfa954e467fe5eb7a666a8f9c3758600ec635daf3d89126ea4c9ce"
    sha256 cellar: :any_skip_relocation, big_sur:       "3258a5aa80903392c95fc08ddf1f78e0a785b7800777e4de1df76d6e139af1cb"
    sha256 cellar: :any_skip_relocation, catalina:      "68b802211d0c7bec0def0c699d9960ea51d93ae1bc3248b3d40aab633fc510f6"
    sha256 cellar: :any_skip_relocation, mojave:        "f0082583149595cee580f8d7af1b33006ce5579073e552ed9e18dfd5f9caab21"
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
      \tPolicies Validated  :\t203
      \tViolated Policies   :\t0
      \tLow                 :\t0
      \tMedium              :\t0
      \tHigh                :\t0
    EOS

    assert_match expected, shell_output("#{bin}/terrascan scan -f #{testpath}/ami.tf -t aws")

    assert_match "version: v#{version}", shell_output("#{bin}/terrascan version")
  end
end
