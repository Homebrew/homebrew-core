class Terrascan < Formula
  desc "Detect compliance and security violations across Infrastructure as Code"
  homepage "https://github.com/accurics/terrascan"
  url "https://github.com/accurics/terrascan/archive/v1.11.0.tar.gz"
  sha256 "3fc6289e7fffbb8f8f696e264ec8b1481e741bf5638976b02a9f285398c2afa1"
  license "Apache-2.0"
  head "https://github.com/accurics/terrascan.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "025531bef57c6fb0aac90117f351c41f7087976496ce9a3c0a108c98842101ef"
    sha256 cellar: :any_skip_relocation, big_sur:       "7bf1fba0a3ec89dedffcb69d6c84fa1d07118a28423cf5565b585d74a97f431e"
    sha256 cellar: :any_skip_relocation, catalina:      "a83d25121c4c41de4468f8564f5ae40a5677986172117cc84ee8f7b00d8e54cc"
    sha256 cellar: :any_skip_relocation, mojave:        "a9eee5712ab7cda16dad612c2cc0f8e427257da4b2caca7cffa34ff03094a505"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79d1601bd90c810f2a6cb8134cb74f413c9902a8ecb82b9f39d0f83464e18040"
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
