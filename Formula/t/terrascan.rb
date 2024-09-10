class Terrascan < Formula
  desc "Detect compliance and security violations across Infrastructure as Code"
  homepage "https://runterrascan.io/"
  url "https://github.com/tenable/terrascan/archive/refs/tags/v1.19.6.tar.gz"
  sha256 "4e22fff904c582d806690e5c2a84f657e513d727224c2afb6db86ebbec0bd387"
  license "Apache-2.0"
  head "https://github.com/tenable/terrascan.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6e4cdfea8447537bcc337b8145f708cbfc2ce78e55c455bcb401a1c7caef7ad8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3018b5a87ff23c948ceb15181d05ab1885d01b11ea552b0b5905bc971ee53cc1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "792f6b3d478efd08285628a5ef13001ec2ab0f0a9ad92a7f220618cf17960561"
    sha256 cellar: :any_skip_relocation, sonoma:         "60aa7f4a1745badaa08f69012f97b20a21d6d3c056e656d367b7f796e1d587c4"
    sha256 cellar: :any_skip_relocation, ventura:        "eef54fd868c185679475fa311831cd5b5744e8d0008c3ca68bb020eb7e7a4a8f"
    sha256 cellar: :any_skip_relocation, monterey:       "a652eed61ebfc93b5593b17e7b2f9c46415545aa2097e0f122c466422b4769d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c922dd0e87a4f65339171168c9828730707fe76f0cb723458a8315effd4c1cba"
  end

  depends_on "go" => :build

  def install
    # ignore protobuf conflicts
    # upstream bug report, https://github.com/tenable/terrascan/issues/1702
    ldflags = %w[
      -s -w
      -X google.golang.org/protobuf/reflect/protoregistry.conflictPolicy=ignore
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/terrascan"
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
