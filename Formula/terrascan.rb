class Terrascan < Formula
  desc "Detect compliance and security violations across Infrastructure as Code"
  homepage "https://www.accurics.com/products/terrascan/"
  url "https://github.com/accurics/terrascan/archive/v1.3.2.tar.gz"
  sha256 "f5cab886ca8f0b233060524840280341bcdbc724fb79c08dfdb1ec8f66097a3a"
  license "Apache-2.0"
  head "https://github.com/accurics/terrascan.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "22856f97720230a2db38399bca2ea948981abbcfab712cd92cc09107c042da74"
    sha256 cellar: :any_skip_relocation, big_sur:       "430c828231b47110e56192e22359e52c0b2be9608b835750d6c2e8e7f9437e75"
    sha256 cellar: :any_skip_relocation, catalina:      "3f8196d147f1a96e019272098e369baa73fa0904a490a310454042eba9f01ac2"
    sha256 cellar: :any_skip_relocation, mojave:        "1687e46163119a6cb506a80591b905c5ebcf6b34a8a31294de1a977d190ac19f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/terrascan"
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
      \tPolicies Validated  :	159
      \tViolated Policies   :	0
      \tLow                 :	0
      \tMedium              :	0
      \tHigh                :	0
    EOS

    assert_match expected, shell_output("#{bin}/terrascan scan -f #{testpath}/ami.tf -t aws")

    assert_match "version: v#{version}", shell_output("#{bin}/terrascan version")
  end
end
