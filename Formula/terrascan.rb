class Terrascan < Formula
  desc "Detect compliance and security violations across Infrastructure as Code"
  homepage "https://www.accurics.com/products/terrascan/"
  url "https://github.com/accurics/terrascan/archive/v1.3.1.tar.gz"
  sha256 "8be53cec9a55691bf14d035c99417b7566e43abeee1fd152e8fb9ef69ea67119"
  license "Apache-2.0"
  head "https://github.com/accurics/terrascan.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f651acbd7467858a3edb9b320c71473ec6949686bf095aadffb1696d3d1921b2" => :big_sur
    sha256 "2b44fb20d0dd5794a028d0c897f3335bb4d1aa4f23cec2be26a58c473977c9f2" => :arm64_big_sur
    sha256 "c2b0cb042bf6b3739e77d391eda6e3b1eceffc3d746c81194772daa074426ffd" => :catalina
    sha256 "bab112682da7663edec11998f40bf43753ee8793bd1107722e92376c7ffe2fa4" => :mojave
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
