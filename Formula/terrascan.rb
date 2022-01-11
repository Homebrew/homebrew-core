class Terrascan < Formula
  desc "Detect compliance and security violations across Infrastructure as Code"
  homepage "https://github.com/accurics/terrascan"
  url "https://github.com/accurics/terrascan/archive/v1.13.0.tar.gz"
  sha256 "20d7f92a88168fa803dc62323c91fbd9e7c707cc1161865053e8a9e752e170e9"
  license "Apache-2.0"
  head "https://github.com/accurics/terrascan.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ea062b0f2155e618d9e98bd416914286a58cac6d9b333951423c65a722f2da6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6c18ba2801e9d4b95edf10d7cfb2901cb590c846a72517a9eceef6a781b2723f"
    sha256 cellar: :any_skip_relocation, monterey:       "8e8049a0640daefacd1da2a29002361cd5f78276c382df89ce4cfbf49c8c6e32"
    sha256 cellar: :any_skip_relocation, big_sur:        "b6c19018c4a2bc9ff53f4ae0a88440643151666b527820d60d8083b117f0a4c3"
    sha256 cellar: :any_skip_relocation, catalina:       "be566ccc3d2be24bf9def0ae7c0af7c0b2b6dbbc3de25d7954ebd62f8d93351f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78b5ba32c8b39a56c7ee33526fc3615d0ac0c153176d877cf28f1dd64d25af97"
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
