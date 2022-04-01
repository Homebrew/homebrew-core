class Terrascan < Formula
  desc "Detect compliance and security violations across Infrastructure as Code"
  homepage "https://github.com/accurics/terrascan"
  url "https://github.com/accurics/terrascan/archive/v1.14.0.tar.gz"
  sha256 "6c7510c6e3e02259af368fcb246ce77735f4d49f35ccfb6c835d592d6468c203"
  license "Apache-2.0"
  head "https://github.com/accurics/terrascan.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d41840e91df89e57a4ce08e3016ac7d963cddff94bd88f570f5c31e8bd80a40e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d3e49366f64a14e16a27aa718a497ba4f4d17ac5e53c70b15a85c5566e1606f8"
    sha256 cellar: :any_skip_relocation, monterey:       "0b9a308561e61a7464ff45af3794a23297ac9ddc335e681a7eb490b1a93b5a9c"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee861a266d51304cff5975abdca1348156e7ef67ae0dabca83686b91b3bb450e"
    sha256 cellar: :any_skip_relocation, catalina:       "1b3ed5aae2ef0cebe7e1c683b0fb97d74ab749a4ecc6c7828b066c969d7b19ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df03b60cbd2bc4a983d90e7180e2238889d607752d4d91837c0da7addd4fc9e7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/terrascan"
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
      \tViolated Policies   :\t0
      \tLow                 :\t0
      \tMedium              :\t0
      \tHigh                :\t0
    EOS

    output = shell_output("#{bin}/terrascan scan -f #{testpath}/ami.tf -t aws")
    assert_match expected, output
    assert_match(/Policies Validated\s+:\s+\d+/, output)
  end
end
