class Terrascan < Formula
  desc "Detect compliance and security violations across Infrastructure as Code"
  homepage "https://github.com/tenable/terrascan"
  url "https://github.com/tenable/terrascan/archive/v1.16.0.tar.gz"
  sha256 "92013eca7397efcae5bbcf2b94d13494a048b5e872ae2c16bc352e7c383917e0"
  license "Apache-2.0"
  head "https://github.com/tenable/terrascan.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79b0e3e584a961edccf6d97483dbeec29aac981d334a17b25a54b6a0eff10726"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2a2b26ba4fb928a1d1f3f5492b412adfd10e27872f3d60b809d8cdcba3c0ea9a"
    sha256 cellar: :any_skip_relocation, monterey:       "61abde8107ea430a6dc6df61b6e562379da63bd4ead284bdf9c4641876fce4bc"
    sha256 cellar: :any_skip_relocation, big_sur:        "3cc64662700c0927078ed5491dc135907f76e1df4aee29b5511f684d4fe39d72"
    sha256 cellar: :any_skip_relocation, catalina:       "5391d917a47967f97b249fceeb8cf632b6b2fcd0eac60abc2d8b9093f82f552f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8825c5897fc4f8524ec7bfb0f48640e4f89d5d86714b98864bd1ca7e992b3fcb"
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
