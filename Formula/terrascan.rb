class Terrascan < Formula
  desc "Detect compliance and security violations across Infrastructure as Code"
  homepage "https://www.accurics.com/products/terrascan/"
  url "https://github.com/accurics/terrascan/archive/v1.0.0.tar.gz"
  sha256 "2ee36f5d2e21134cd9fea386ebe23a3b89bfe1c7693e0de54d79014ec47c7097"
  license "Apache-2.0"
  head "https://github.com/accurics/terrascan.git"

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
