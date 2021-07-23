class Terrascan < Formula
  desc "Detect compliance and security violations across Infrastructure as Code"
  homepage "https://github.com/accurics/terrascan"
  url "https://github.com/accurics/terrascan/archive/v1.8.1.tar.gz"
  sha256 "5d825d765328c620e99c06e622b5c9d3c2d1aa15b23e380bcf076aba788b1b5e"
  license "Apache-2.0"
  head "https://github.com/accurics/terrascan.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4b8b9d18abb44c10d94e14646ded77c3fe09b976b6964cadef5d8811af7907f1"
    sha256 cellar: :any_skip_relocation, big_sur:       "7a740f8c40d28cfb1979c700103f8a8f7d7165521280c95619fa7d06fb369834"
    sha256 cellar: :any_skip_relocation, catalina:      "7ff20e87a1252534a3561bf51e63c750193502c66759523b6634c972e2bd5e3b"
    sha256 cellar: :any_skip_relocation, mojave:        "e377cf1ef7af9b28db473860e08a0b855a3e8e0ff985cca15c2865f7e7e0d263"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dcb4e9f3316d5e348b6b515beeb9e3399acbf9eed44c5c367f10d403b1386db9"
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
