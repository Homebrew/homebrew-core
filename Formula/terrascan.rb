class Terrascan < Formula
  desc "Detect compliance and security violations across Infrastructure as Code"
  homepage "https://github.com/tenable/terrascan"
  url "https://github.com/tenable/terrascan/archive/v1.17.0.tar.gz"
  sha256 "b9d8448e7bb94d6fd352f9d7fe6a2426253ff1dc7460c4ca12fa7fce74684255"
  license "Apache-2.0"
  head "https://github.com/tenable/terrascan.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "89fe3b80c44367ddafb43e11af73df6ae6b7b13185e3cb16d6f1226c514a13f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4150c9143a7619c1bfc0d79c6cb2ca3d54f3e5a29b88f3875da0accb24ebc74"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c8320ca46467b26375cfd9ca53ea62d927fd0a312dd3ab165cb143a17836c6c6"
    sha256 cellar: :any_skip_relocation, ventura:        "8984e004c50f7a11e1b1621f6ac9dd7685cdf1569cd97e36e0ecc7236e782eba"
    sha256 cellar: :any_skip_relocation, monterey:       "a73c8ccd3c2bc8548a584d92bc4f2e35f33224427033272fd3ad332c45f031c8"
    sha256 cellar: :any_skip_relocation, big_sur:        "dc96b214ba2ec4d6720bf602ed66e07357bcb0b24bb755de1fd82d56070a9abc"
    sha256 cellar: :any_skip_relocation, catalina:       "f7c1446677dec200d8e13122fec823b4430fe352e95c456a7b6bc4d048f9b319"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "531a4daedc06877a65ce1b1f9a7d29ecaece8252d876639abeb63d82bdce113c"
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
