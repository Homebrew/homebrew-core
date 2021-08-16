class TerraformDocs < Formula
  desc "Tool to generate documentation from Terraform modules"
  homepage "https://github.com/terraform-docs/terraform-docs"
  url "https://github.com/terraform-docs/terraform-docs/archive/v0.15.0.tar.gz"
  sha256 "0be7d2eb0893acb79027287d8873f1c2dc4cc7f38f63889eebf59bc546b3dc8e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7ba0b7a03e9b8d8fa699aa5c4b8b75afbced3619759e04c562acaa8c85c07d63"
    sha256 cellar: :any_skip_relocation, big_sur:       "d84844fbec03d7e377441da0fd6658f7c4430a5a7084887102a7ef187ec28143"
    sha256 cellar: :any_skip_relocation, catalina:      "97eb0dc4b26e4be336b6c52e7d7e23c9cd415e92edee8566009d1196890faa7a"
    sha256 cellar: :any_skip_relocation, mojave:        "1d1533ac73741244c1a868a6a7c0ca87aede41d7e0348bf8c62f213fbaffa81f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7aa6e7cb97366633cdf2f4b7a7c10e12025bd9e0eee28663b5be03e95a03e03f"
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
