class Terrascan < Formula
  desc "Detect compliance and security violations across Infrastructure as Code"
  homepage "https://github.com/tenable/terrascan"
  url "https://github.com/tenable/terrascan/archive/v1.18.0.tar.gz"
  sha256 "b6cf06567d2a9ea5b059dadf65845d1d7c390c26e6d07c726a18ed7dc7c1b8b3"
  license "Apache-2.0"
  head "https://github.com/tenable/terrascan.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f5ea1da0393ff61166237004d2182e8a29a54db16b20962cb11ff5de8e5c76d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75c2c08957a8fea97d0f88b1339d47238f350518cdafdffcda1e2bfe23fe5f5e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1c9752562cd0245f362dd3de22e884739cc16b99dab7183fd21be4f641c6a6e7"
    sha256 cellar: :any_skip_relocation, ventura:        "d02cac2280bca0322a18d12da96804044ee9545519bc1e8a219a66d281939bf1"
    sha256 cellar: :any_skip_relocation, monterey:       "c795912b9a3aae9b6201aa7473cee37d8b2c0e72b45dba92071c75a791921854"
    sha256 cellar: :any_skip_relocation, big_sur:        "2b48497fc06d21f201b38cc0965077778a8b83ae87fc78aed94451e2c8cdee61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a0dce8700551a079f75a281ee1cedff91dc248b758e9c9946fe1d71b2d4be41"
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
