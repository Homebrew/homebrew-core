class Terrascan < Formula
  desc "Detect compliance and security violations across Infrastructure as Code"
  homepage "https://www.accurics.com/products/terrascan/"
  url "https://github.com/accurics/terrascan/archive/v1.3.1.tar.gz"
  sha256 "8be53cec9a55691bf14d035c99417b7566e43abeee1fd152e8fb9ef69ea67119"
  license "Apache-2.0"
  head "https://github.com/accurics/terrascan.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "911488ef4e334a7496edeb386a656bb8b5aa48de81c2ace70ea22cd857e79289" => :big_sur
    sha256 "99003f4d8cede3a65bc5fcc494cc6d03349b150b4ef27c37d3bfca06799db5c0" => :arm64_big_sur
    sha256 "3d66e898e68386b23fae88df32df00a46ec1a03d1431c36aeadc96e3a233b52d" => :catalina
    sha256 "6337a9985ded331f613fa958daf4d444feba3174d127997b6120891817afb1fb" => :mojave
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
      \tPolicies Validated  :	149
      \tViolated Policies   :	0
      \tLow                 :	0
      \tMedium              :	0
      \tHigh                :	0
    EOS

    assert_match expected, shell_output("#{bin}/terrascan scan -f #{testpath}/ami.tf -t aws")

    assert_match "version: v#{version}", shell_output("#{bin}/terrascan version")
  end
end
