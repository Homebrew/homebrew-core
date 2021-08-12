class Terrascan < Formula
  desc "Detect compliance and security violations across Infrastructure as Code"
  homepage "https://github.com/accurics/terrascan"
  url "https://github.com/accurics/terrascan/archive/v1.9.0.tar.gz"
  sha256 "175af8ae4d432b735ba6c638bd4d85b9185c4dae0422f13495d9dfb0c40916de"
  license "Apache-2.0"
  head "https://github.com/accurics/terrascan.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "dfbf9d7877f46520224f71ec7a3b8fb9db00fde330188f67fdfd57e2ec5987ed"
    sha256 cellar: :any_skip_relocation, big_sur:       "8ba6c5bfeb6f48c7df0ff3a678ca6c6aa5e44189dd020000a16135bb458b99d4"
    sha256 cellar: :any_skip_relocation, catalina:      "2bbcceefacfa43f3db9352f1746d6dc80355740a90617267e08b4964a9e36c9e"
    sha256 cellar: :any_skip_relocation, mojave:        "2e47b1cba9f52811805dbeb465c22a17fe08b0ef53b3a65e0b91d70f51f17bde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b731e746281d61cf933537eca3b542fbb18d6dfe46ed65c6967c8eb6a7e2c0f3"
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
