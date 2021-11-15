class Terrascan < Formula
  desc "Detect compliance and security violations across Infrastructure as Code"
  homepage "https://github.com/accurics/terrascan"
  url "https://github.com/accurics/terrascan/archive/v1.12.0.tar.gz"
  sha256 "66ec203e518d3887bf14a2535e98e9cf64dfc4b2c667655a0055dc3df8f6be78"
  license "Apache-2.0"
  head "https://github.com/accurics/terrascan.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f41e265104455f16b7723a371fac5823d61d25f19c5c5a9726b6759a9297d356"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7d243409f95334d8070c4e10d3e38861f8955b8ea487aee56f781eee6a3b8a2f"
    sha256 cellar: :any_skip_relocation, monterey:       "fe0ad5715c09496cedb7666ebc399a054a1539410e8ca65a13bd9d0d5745db69"
    sha256 cellar: :any_skip_relocation, big_sur:        "472c96bee9ca661ca7d6fc5d427561c928ca9a7b5ce21dbeb18e6af776ceeb93"
    sha256 cellar: :any_skip_relocation, catalina:       "dfa5a396feccebf1afb2ac23a412cb3fca1cf0bf45ee1e815ca13288fd70ecd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "775b5d6a4a5a8b098b3856ecb14f56afa9781d44e6b9976139d262f95dbfe37a"
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
