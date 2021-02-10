class TerraformDocs < Formula
  desc "Tool to generate documentation from Terraform modules"
  homepage "https://github.com/terraform-docs/terraform-docs"
  url "https://github.com/terraform-docs/terraform-docs/archive/v0.11.0.tar.gz"
  sha256 "70fdb2f07c26a5a8037ad46470f10715de14b48d38ccd529f6c8cd0be4e27b49"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e71ab1c7e1de44a2eb3fc0ec3ef3fed9d416b6e3b99899e8b37b3e576e6bef72"
    sha256 cellar: :any_skip_relocation, big_sur:       "708d1222ce92c824f71955ff045061361eff540c327fa8ae192c605e4b478f31"
    sha256 cellar: :any_skip_relocation, catalina:      "7c205585f865eea81a89e4a696d26edf83e8e4acaaba85a7d8a3b580af7fcb66"
    sha256 cellar: :any_skip_relocation, mojave:        "dd0e283a27b14f79de20297889832d0045746ff96335aa43d7a5ed030f099387"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    cpu = Hardware::CPU.arm? ? "arm64" : "amd64"
    bin.install "bin/darwin-#{cpu}/terraform-docs"
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
