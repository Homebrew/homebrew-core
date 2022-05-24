class Terrascan < Formula
  desc "Detect compliance and security violations across Infrastructure as Code"
  homepage "https://github.com/tenable/terrascan"
  url "https://github.com/tenable/terrascan/archive/v1.15.1.tar.gz"
  sha256 "3d0588ea411f3cd2a47803ab1fe3e0f92b75a48e29109f843cb99700c083fc66"
  license "Apache-2.0"
  head "https://github.com/tenable/terrascan.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6391e53f88655344b1bcf87c5d7b762beeca98617695bd2443744f60e38b0ace"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2bd8ac2c007ea3769acce43a7afcc0e1d167a1642643e78ee9b5587cab85f806"
    sha256 cellar: :any_skip_relocation, monterey:       "ddccc3912725170ddc975c7128fd4d973209a958f36649b014e3e7b90ca4e1ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "6605379f6b8641891f4a60906987256e82d2b5fce6819d5b0981cd73e1fc5500"
    sha256 cellar: :any_skip_relocation, catalina:       "b50cbe49d7d715da3c9b3d2c4d47fb00a34b7fd2c807d26596e280a16366b3ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92231bf958a345a8fac5673ae056802178271c7608f2337710b4e266ccf7b687"
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
