class Terrascan < Formula
  desc "Detect compliance and security violations across Infrastructure as Code"
  homepage "https://runterrascan.io/"
  url "https://github.com/tenable/terrascan/archive/refs/tags/v1.19.9.tar.gz"
  sha256 "13c120a63d7024ca8c54422e047424e318622625336ed77b2c1a36ef5fb1441c"
  license "Apache-2.0"
  head "https://github.com/tenable/terrascan.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "036641e1af3550fa344928b99fdabcb1b11961e3b0812bb15f8f3cddaa259023"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c5210ca6ec0c8dd636a8e5a154f8ea0b75361beead716efbd83143b4475d986"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "835ec90adf52e9d99a51bdc96789a542529bcdcf21c5e511c2f0ed961c5a1dff"
    sha256 cellar: :any_skip_relocation, sonoma:        "c48066b69004a0dca1cbc0c5c8071430f9bb61c208a85c43e1814a3d48573614"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca058cf4a6962757ebe84e7c2c4a910a53a17f26a52f6b7675248c6437613f1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1da9aea6b543cbb9ffb3716413505ed1ed0ec1ad731a62309b54c39211ab3b51"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X google.golang.org/protobuf/reflect/protoregistry.conflictPolicy=ignore"
    system "go", "build", *std_go_args(ldflags:), "./cmd/terrascan"

    generate_completions_from_executable(bin/"terrascan", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"ami.tf").write <<~HCL
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
    HCL

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
