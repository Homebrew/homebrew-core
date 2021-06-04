class TerraformDocs < Formula
  desc "Tool to generate documentation from Terraform modules"
  homepage "https://github.com/terraform-docs/terraform-docs"
  url "https://github.com/terraform-docs/terraform-docs/archive/v0.14.1.tar.gz"
  sha256 "6c3157cb7eaac2e62b32556ab9cd5f83e58c2934aa3eb7c1e61c00c7c5b1e186"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6c2bae9abc34119abfb656979cfcfdca40cdb235fe5621807d879f6016159d27"
    sha256 cellar: :any_skip_relocation, big_sur:       "47c837d6ceed7dd58008f98abc6dda7e2d5bcc7fc86564e895ab61df2d8b83ab"
    sha256 cellar: :any_skip_relocation, catalina:      "9c17f4fa41db947ff3d11fce84b21be9bc497ea79728c84c9b35110614857294"
    sha256 cellar: :any_skip_relocation, mojave:        "f295cd5412830ff30abe601dbedd2436b01ad4bebd20f7d271a691bc247bab1f"
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
