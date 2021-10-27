class TerraformDocs < Formula
  desc "Tool to generate documentation from Terraform modules"
  homepage "https://github.com/terraform-docs/terraform-docs"
  url "https://github.com/terraform-docs/terraform-docs/archive/v0.16.0.tar.gz"
  sha256 "e370fd106ca74caebc8632834cc28412a3a6a160952392da71f213515bba2085"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f2f4cf6fcf375be8963c87892a9949fd415f3bd7d91cf7c2e6ecbd51525aaf8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4019590722af255f89f39cb67f6a032bd5ccc2fb50f8949c7928215b215cf6f7"
    sha256 cellar: :any_skip_relocation, monterey:       "2feecfdf034d99b6b9de4d20d377d91d546c800fdcf3efb32ab8fc74936af84b"
    sha256 cellar: :any_skip_relocation, big_sur:        "a8bd7087f7d1b8f351c44cef6ddfe5a8adcdc06999665f0f46b0d9753d2e50f0"
    sha256 cellar: :any_skip_relocation, catalina:       "434ec046eb696cc5a6eded18b8afca8e346e7009165d9a8e12e88ffb3fc3811e"
    sha256 cellar: :any_skip_relocation, mojave:         "dae4a1d6f4dd664f8388a19a55d037b9a63e76f1ee704b1e4ec993892234bd83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b66e3b532c81e093416f3b7e2af35295b8f9887ef1d662fe836a7b1f0ac7dbab"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    cpu = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    os = OS.kernel_name.downcase

    bin.install "bin/#{os}-#{cpu}/terraform-docs"
    prefix.install_metafiles
  end

  test do
    (testpath/"main.tf").write <<~EOS
      /**
       * Module usage:
       *
       *      module "foo" {
       *        source = "github.com/foo/baz"
       *        subnet_ids = "${join(",", subnet.*.id)}"
       *      }
       */

      variable "subnet_ids" {
        description = "a comma-separated list of subnet IDs"
      }

      variable "security_group_ids" {
        default = "sg-a, sg-b"
      }

      variable "amis" {
        default = {
          "us-east-1" = "ami-8f7687e2"
          "us-west-1" = "ami-bb473cdb"
          "us-west-2" = "ami-84b44de4"
          "eu-west-1" = "ami-4e6ffe3d"
          "eu-central-1" = "ami-b0cc23df"
          "ap-northeast-1" = "ami-095dbf68"
          "ap-southeast-1" = "ami-cf03d2ac"
          "ap-southeast-2" = "ami-697a540a"
        }
      }

      // The VPC ID.
      output "vpc_id" {
        value = "vpc-5c1f55fd"
      }
    EOS
    system "#{bin}/terraform-docs", "json", testpath
  end
end
