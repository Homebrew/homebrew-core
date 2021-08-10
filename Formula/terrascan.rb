class Terrascan < Formula
  desc "Detect compliance and security violations across Infrastructure as Code"
  homepage "https://github.com/accurics/terrascan"
  url "https://github.com/accurics/terrascan/archive/v1.9.0.tar.gz"
  sha256 "175af8ae4d432b735ba6c638bd4d85b9185c4dae0422f13495d9dfb0c40916de"
  license "Apache-2.0"
  head "https://github.com/accurics/terrascan.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0838d087bcbf937dcf52f426b972a8655f99702058ea1c468c55f3e9fa78338f"
    sha256 cellar: :any_skip_relocation, big_sur:       "20818e3dbfae630b183495f9043a04b629e5a48d37b2ffffbc690ae179fdb107"
    sha256 cellar: :any_skip_relocation, catalina:      "cff769df251f2e66407ce3225a1fa9466c9e0293aaef440958540e7779ecc990"
    sha256 cellar: :any_skip_relocation, mojave:        "fda72bbd58f8344225f528d3128a12b81732112916f32349282e6fd80dbfa6be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "477f911bc9d88838cae50861504786a0891af88549c060dd012b2a33a49c8e5b"
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
