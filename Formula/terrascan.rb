class Terrascan < Formula
  desc "Detect compliance and security violations across Infrastructure as Code"
  homepage "https://github.com/accurics/terrascan"
  url "https://github.com/accurics/terrascan/archive/v1.14.0.tar.gz"
  sha256 "6c7510c6e3e02259af368fcb246ce77735f4d49f35ccfb6c835d592d6468c203"
  license "Apache-2.0"
  head "https://github.com/accurics/terrascan.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5a6995a2ba112ada31b3a111e2c5e2887649c9f0dbd4e56155d5fe5f5cc2941"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "441b2b6bd417c12a7b2fe3127625174760d43a2cf76b8d8ee416d720df8adef0"
    sha256 cellar: :any_skip_relocation, monterey:       "4c7bf4a7e62977d88463f2b0d0bc49cf37ef2e92f97be54b22bf0d92ef1c7f45"
    sha256 cellar: :any_skip_relocation, big_sur:        "fe0748c7b298c14606d3723e35815243d8675de353f1706ba9aa3bc336169ab9"
    sha256 cellar: :any_skip_relocation, catalina:       "366e035d0008323af402b71374ce566682e4942b9db88546c56329eaaad902b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2712de4456a81ec3109d5fdcb5100bd9741865029339ea60b204cdfe790c581c"
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
