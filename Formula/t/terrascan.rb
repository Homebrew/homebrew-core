class Terrascan < Formula
  desc "Detect compliance and security violations across Infrastructure as Code"
  homepage "https://github.com/tenable/terrascan"
  url "https://github.com/tenable/terrascan/archive/v1.18.3.tar.gz"
  sha256 "214f96d009d2aed4e589b456e469c7ebc2225329c124a082f05d961e481e158b"
  license "Apache-2.0"
  head "https://github.com/tenable/terrascan.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "461ff9bc01555c0027ee35c47023bd42a1d83c509410c3373a6c0e64b3d803a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2cfa6ef466a099cba86462f587c91a9c3e26fcd68b1a3b820a6ca671975789e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aeed001333afc15e2f9251642bd8c0eb731f9766874d1ed7ba44355b338b98fa"
    sha256 cellar: :any_skip_relocation, ventura:        "eb2cf1c5c897aeb34ff80ba721a74650bb7a3ed6a9e971643e38b4089ac7eb9c"
    sha256 cellar: :any_skip_relocation, monterey:       "377cd3d30d3142fd714846f4b07c50e1016bcc04872367ebd3cc44915176222a"
    sha256 cellar: :any_skip_relocation, big_sur:        "37926d5c24058e236994513c8d685e47c9a381444c67a6d10c58a0242ae18232"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dac495eb1901a28dfc1cd11abf8a606178fb89eebc955989299a4b4181fc718f"
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
