class TerraformDocs < Formula
  desc "Tool to generate documentation from Terraform modules"
  homepage "https://github.com/terraform-docs/terraform-docs"
  url "https://github.com/terraform-docs/terraform-docs/archive/v0.14.0.tar.gz"
  sha256 "d7cd702969fcb50594767fbda3a4bb5435736edf14cfcdfd82cf5fc40c16da3e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "257027207cfba25739ca1dbaee1ff3e1ccb16eb9eee61bcbda2849c6f3117919"
    sha256 cellar: :any_skip_relocation, big_sur:       "e0cb781cca69a94a8801bbe292be4fd1ed391ce810f06af6beee097b82e77827"
    sha256 cellar: :any_skip_relocation, catalina:      "05ee4a45267b31f8effc3a372325b80e35a4e75311267b5bd4ca6dbdb4658415"
    sha256 cellar: :any_skip_relocation, mojave:        "554e555cd08e18aa57c39bd28214e00fe19503a1519b3e1148d87224dd44ba31"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    cpu = Hardware::CPU.arm? ? "arm64" : "amd64"
    os = "darwin"
    on_linux do
      os = "linux"
    end
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
