class Terrascan < Formula
  desc "Detect compliance and security violations across Infrastructure as Code"
  homepage "https://www.accurics.com/products/terrascan/"
  url "https://github.com/accurics/terrascan/archive/v1.4.0.tar.gz"
  sha256 "6bb231500f7b08c5f36fe1193cd9ba17a036e0a81a7ccf752edf2d958784035f"
  license "Apache-2.0"
  head "https://github.com/accurics/terrascan.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d134c7faf143bcee70a7efd729a68aa9d72c4fc6941672b3a98952fc26b84b3d"
    sha256 cellar: :any_skip_relocation, big_sur:       "660a6ec36404c9e45899249c9f1ac250ac6cdf30a5514dfe52877cbe6954a1e5"
    sha256 cellar: :any_skip_relocation, catalina:      "f5a93d7392ad8c451a2a6a1379c1d3c9a889583215bfed8b66ca74267b321a5a"
    sha256 cellar: :any_skip_relocation, mojave:        "be0816e6a545a340880459362b55310674443f2f97f2a7dba7c704a890c4a6d3"
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
