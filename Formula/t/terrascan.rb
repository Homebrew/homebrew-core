class Terrascan < Formula
  desc "Detect compliance and security violations across Infrastructure as Code"
  homepage "https://github.com/tenable/terrascan"
  url "https://github.com/tenable/terrascan/archive/refs/tags/v1.18.6.tar.gz"
  sha256 "be35828d6998007c9892d4f7df9a2958921f5e36af8f1eadb0528cf6680ac225"
  license "Apache-2.0"
  head "https://github.com/tenable/terrascan.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5c211276e89e92d9a66ca7dbed6098b97718f526da7262b53fd19b3c3ee52141"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c7ed8cdfa889635827faf354d086ff73f50abd2bb1afceb55bea0826e265f23"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4bc06038501d0ebe3657db3fa2fc647d50aaf1208b073cb76df507c7363cf61"
    sha256 cellar: :any_skip_relocation, sonoma:         "999cfbf9c385a6590c6ab2e0b3f920ba530117178435a4facb6b8b618da0dce0"
    sha256 cellar: :any_skip_relocation, ventura:        "02b75c45dfc23335f43946e4ba749776d9293699e7aa287df7efebdbfb0f871b"
    sha256 cellar: :any_skip_relocation, monterey:       "1871bdaddea20b484c4489dd22cb5d60e07d9044ab915cae6049c571dccb29d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94c6ae86c871dcef038b0065e47915ecc532cbe1fd3daafbd2f5951d8cd68244"
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
