class Terrascan < Formula
  desc "Detect compliance and security violations across Infrastructure as Code"
  homepage "https://runterrascan.io/"
  url "https://github.com/tenable/terrascan/archive/refs/tags/v1.19.2.tar.gz"
  sha256 "ee6a20478be054b5923e53fbba7c23b4318af69bbd50d52764dd61bb9b3df5a5"
  license "Apache-2.0"
  head "https://github.com/tenable/terrascan.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c1fe26fa4506aceb1548d91b04aed33059e7d65b468538b303d1104fea1c87af"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9f6855fa23b29eb5a4c320c82663f1cc14a4ccf6ee40ce404598e0d9092e5ed8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed7b828a6959fa262351849ca4e3749fff21a3962a80c52abe7be94f50c988c2"
    sha256 cellar: :any_skip_relocation, sonoma:         "4a60fe1a530a0c3b5dc8960849360a62ea56e318f1f238798ba07f8832ba9863"
    sha256 cellar: :any_skip_relocation, ventura:        "388403e99a32658306cd40be2388e77d8f9cc42196e0f833ca437c492d05c874"
    sha256 cellar: :any_skip_relocation, monterey:       "0e0b81b1edab07a622d140f79d8a4cdccca259e108f3b9708dcf7fa03b41d455"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3861290bb7c8ed075cf501366470d7ed902b7cf96cd73b539755e75992b206e1"
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
