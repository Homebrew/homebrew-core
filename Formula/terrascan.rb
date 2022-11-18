class Terrascan < Formula
  desc "Detect compliance and security violations across Infrastructure as Code"
  homepage "https://github.com/tenable/terrascan"
  url "https://github.com/tenable/terrascan/archive/v1.16.0.tar.gz"
  sha256 "92013eca7397efcae5bbcf2b94d13494a048b5e872ae2c16bc352e7c383917e0"
  license "Apache-2.0"
  head "https://github.com/tenable/terrascan.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f8a684ecd34c5727a09f2d86bb3d6080f9608f67775c98ac7fa770593de59fca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f2c90377860bbce26b5a66f51bd8d482d653b3b5376bb3251fdfe6981794a4a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "87572715d141f8d4ce936888d2f4a2283d95d0a40791f56e64e650a538fe3a14"
    sha256 cellar: :any_skip_relocation, ventura:        "f34643d3d70af4a677344d89b8e8051fd6b17e20af91afdd0b0a32d0b2dbdb53"
    sha256 cellar: :any_skip_relocation, monterey:       "a2611af8389bcf3f2c78882cb7e90bd9f52ed4bf101ceee97d20d8cc8284bf79"
    sha256 cellar: :any_skip_relocation, big_sur:        "a5721af056bc6cdda3d7bb75420b3fe3f74d7578ea729f947ebdf60d969e91e1"
    sha256 cellar: :any_skip_relocation, catalina:       "5e59c49272ac8a37fd83c456e4bba353bf1111b18f817853abd642498124c1f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96efb9ee81cf6d1d60630631fd7cc658722308e55529184d1f34c0ea7358fc9d"
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
