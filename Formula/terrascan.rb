class Terrascan < Formula
  desc "Detect compliance and security violations across Infrastructure as Code"
  homepage "https://github.com/tenable/terrascan"
  url "https://github.com/tenable/terrascan/archive/v1.18.0.tar.gz"
  sha256 "b6cf06567d2a9ea5b059dadf65845d1d7c390c26e6d07c726a18ed7dc7c1b8b3"
  license "Apache-2.0"
  head "https://github.com/tenable/terrascan.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f2d9d265203fa425b26cb96da0c6e59bf7f1cb3adb55316d843200f5f096e1f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "764f47838c65dbb72f13350bf18cec5e1be0a9e03ab090b3e92050373c3f0e5c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "161975deb3ea6d7d9969cd479adc251f043859c192e55d2543400f1f71a4cd33"
    sha256 cellar: :any_skip_relocation, ventura:        "4a6e30c205280ea3b608691dceb551767f736d0ca7f550fc71773cb524197f7e"
    sha256 cellar: :any_skip_relocation, monterey:       "373ab485512274294574c51ab8f4e49cd94a0fa3dc39aebf5fc2be98ab8e33df"
    sha256 cellar: :any_skip_relocation, big_sur:        "f6f1bf46e70c6ee86b351dc49cf5192c84749d87bd2c3b30956e1389540daa43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75e0a51531784c157e90310c05515f4ca248e2bb47c56386fe78d83670927d64"
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
