class Terrascan < Formula
  desc "Detect compliance and security violations across Infrastructure as Code"
  homepage "https://github.com/accurics/terrascan"
  url "https://github.com/accurics/terrascan/archive/v1.7.0.tar.gz"
  sha256 "6ee3f5d915ab20c70a479aa5d598d71e9da54bacaf5239e2f6514605a81da3de"
  license "Apache-2.0"
  head "https://github.com/accurics/terrascan.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4aa9e5ffc6ad9929fd47cd13ce2e3a48336993603877750191ad380a30c1dea1"
    sha256 cellar: :any_skip_relocation, big_sur:       "3bb36a6b1112df06e24e08054b76dc100e2b87fd96ea6df0aae0a90d9eca3ef4"
    sha256 cellar: :any_skip_relocation, catalina:      "d4ddea335cefe9360673414dcada6144f315761aa28f02a3ae355262becc0abf"
    sha256 cellar: :any_skip_relocation, mojave:        "e262178b11a8a43d7d4922fd83520536eab0c5fa18902d2a45d9a49424740d00"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/terrascan"
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
