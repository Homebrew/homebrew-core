class Terrascan < Formula
  desc "Detect compliance and security violations across Infrastructure as Code"
  homepage "https://www.accurics.com/products/terrascan/"
  url "https://github.com/accurics/terrascan/archive/v1.3.3.tar.gz"
  sha256 "1833ea91eee3b94df1f989123fe72eb75facde5e6c08d9e5918ed444d1f11e12"
  license "Apache-2.0"
  head "https://github.com/accurics/terrascan.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2c6c5a64298215d0a8ffa9218d8634a8f494e60d1866360e7815471990e4aa42"
    sha256 cellar: :any_skip_relocation, big_sur:       "bb4316908948dd0c0a31be860e96bb4f03dec665f25c8eed3acdce48e8dd8fc5"
    sha256 cellar: :any_skip_relocation, catalina:      "e407a49f29034a5e84ea3009c6fe22ffe54949babcbc3bc49e51b6161ac42d62"
    sha256 cellar: :any_skip_relocation, mojave:        "fedb40bece9d0d248b7daeb016ee7d7c16a5d4197d559990de1c859c9d215255"
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
      \tPolicies Validated  :	159
      \tViolated Policies   :	0
      \tLow                 :	0
      \tMedium              :	0
      \tHigh                :	0
    EOS

    assert_match expected, shell_output("#{bin}/terrascan scan -f #{testpath}/ami.tf -t aws")

    assert_match "version: v#{version}", shell_output("#{bin}/terrascan version")
  end
end
