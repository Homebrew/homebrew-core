class Terrascan < Formula
  desc "Detect compliance and security violations across Infrastructure as Code"
  homepage "https://github.com/tenable/terrascan"
  url "https://github.com/tenable/terrascan/archive/refs/tags/v1.19.1.tar.gz"
  sha256 "e3ebce8fb568cd1e95dc0d65efaedd494395f38f24a992c0d7b2992ad5aa4710"
  license "Apache-2.0"
  head "https://github.com/tenable/terrascan.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eea2023b14d5c5687e0378391bfed26f0c4cd614d132252068180cab7aab2810"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af895d9a429bc0ce51103a0d7cc5453030d8b5170e9796cead549545da3327ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c790d8e14b57c390fc8d4eb7428ca36316e1fb3955a243ed37ddfb1fb2d2026e"
    sha256 cellar: :any_skip_relocation, sonoma:         "2cc050d0a9a7baf735e4160e4dd24a7d2cb2c16ccafc5dfc58fba9aa05b75cb4"
    sha256 cellar: :any_skip_relocation, ventura:        "4309e1acab8e088bb14b03cfdca25dbd7047d2ed0d22315d762706083a6d5626"
    sha256 cellar: :any_skip_relocation, monterey:       "2b2acfe57c14b214dbd7934d59ed70d2da26380efcc2f1d021b0d67528262fa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0306e0c03d6fae4bba96741a48a2ac3a4ffa105e380deaef74cc800571279c75"
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
