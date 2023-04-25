class Terrascan < Formula
  desc "Detect compliance and security violations across Infrastructure as Code"
  homepage "https://github.com/tenable/terrascan"
  url "https://github.com/tenable/terrascan/archive/v1.18.1.tar.gz"
  sha256 "6539b5c9cd3b6498deaa7d9f714ead3453f6ed7a510bef82a70b146fe5a3d97d"
  license "Apache-2.0"
  head "https://github.com/tenable/terrascan.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b83e4fa3218a7028777cc0ed708a7562a8e0878552c997bd963350060cd26678"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ace80c63b2adeb12d310a63ed46b09d7b82be0120b064db48839f01e38699bf7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4d19b23bfd04b19efa101788f675260aa68e9e604b41c1546bd746cb18ad2018"
    sha256 cellar: :any_skip_relocation, ventura:        "9cbfb664f5e0d9dc394525d3cd7ac0341cd5e49371c10815a9838117cde19d5f"
    sha256 cellar: :any_skip_relocation, monterey:       "ad4a60d3275a3788c2c468ee750cddc3bc29a7e73ddd1cb6cd452c4ccc7e02f5"
    sha256 cellar: :any_skip_relocation, big_sur:        "f99f49317bb90215405bcd1a2bc36ac8fe9bf71c7933fa5d67f971e8a3534426"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3754490c6f58639b9b54517f308433b7e4075549ec0ef2897eb1c1c5d1303e29"
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
