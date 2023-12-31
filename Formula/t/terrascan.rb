class Terrascan < Formula
  desc "Detect compliance and security violations across Infrastructure as Code"
  homepage "https://github.com/tenable/terrascan"
  url "https://github.com/tenable/terrascan/archive/refs/tags/v1.18.11.tar.gz"
  sha256 "1e82a5bb5a270c5f2a7da86fefccc1af6ecf66e5472228af4189e1ee6c3dfdd1"
  license "Apache-2.0"
  head "https://github.com/tenable/terrascan.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4ab0e01beeeed9f23ca99194fb2ed28c799a10a2e092acc2db0f827f4480129f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f953589ef19537235edc5d9b72f7075e4399361a7ef8543f3e9a44b2ed8ac2c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02da158add2da59b6aaa8106039bc2bef6ac63e69cd6f3adaf4ea5fe86acac56"
    sha256 cellar: :any_skip_relocation, sonoma:         "bf283bb60f34c01897aceadff5d6e88a2ad1973f580a08b778083bdbc5ce5a12"
    sha256 cellar: :any_skip_relocation, ventura:        "191b2ab5e49d37ae9bdc861e9c9a6c27a1c09870ee128bea5989e273c0245f6a"
    sha256 cellar: :any_skip_relocation, monterey:       "f67a4585599db7cb0758e49ccee7fba0b8c50d35dedb00d5a568c5a0fd096ce9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e856332e837812bda955f61fe27c06100babe4d6e285e5cf605f56c5064ff418"
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
