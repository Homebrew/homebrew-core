class Terrascan < Formula
  desc "Detect compliance and security violations across Infrastructure as Code"
  homepage "https://github.com/accurics/terrascan"
  url "https://github.com/accurics/terrascan/archive/v1.13.1.tar.gz"
  sha256 "54201de07d9c830a73fdd915d88dcaf6ec6ee23c73e09dbdaf023f227d974b5a"
  license "Apache-2.0"
  head "https://github.com/accurics/terrascan.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f77daff2c3bcd61801851c253a267e4fb5ac495498e92d1256cb86c7218040d9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8bff0f7f3e590c38adf006c323aa23cc51bcd47285414ac3b66ddb60598c4a3a"
    sha256 cellar: :any_skip_relocation, monterey:       "249eede0c48894e25726cfe51895d5fcc516c3e46423deb0e16d39161b3dc4bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "91504e005842dc957fb65d64b8365d447d44a6a15f9c28a45c03a40fb42469d4"
    sha256 cellar: :any_skip_relocation, catalina:       "00d32bbe0df77db7eb3ff5be5cbcb356d0259df13dba301f0683d9c682d8aa8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b51f96a36593522c4b029a809f815cb0267adf63677493c4945cdb61537e7d6"
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
