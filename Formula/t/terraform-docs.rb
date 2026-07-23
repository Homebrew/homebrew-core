class TerraformDocs < Formula
  desc "Tool to generate documentation from Terraform modules"
  homepage "https://terraform-docs.io/"
  url "https://github.com/terraform-docs/terraform-docs/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "e3c971a1f2a02732d964e19e65c901b4e02cca62c4b748c05d22e9690d055540"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fa2cc1277c6cc50f860807570e9bc88868fd24e99e6d68a9d5b4a47ba25dc3cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42b365054923bac534510d13e6b06e7066dae1a431d0d88b67587ad70bb52077"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8305233ffe535dc775e5bbd8d8a00c2dc2a5a3133ec719e920ae65bc54d9e1af"
    sha256 cellar: :any_skip_relocation, sonoma:        "d23f09b9c5ff28efc122d3ef26dfc768aa58d92bc40a13fe291c0a7815901426"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a52f38be0c6f3af1b3dad3c7e13026b20f3ee6ace1b9e5ca9be6d5dfc826f84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21e204b1283a4e3de6fb2aaf6e95edb7486aa6f3424cd0493bbd1ec396ac6997"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    cpu = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    os = OS.kernel_name.downcase

    bin.install "bin/#{os}-#{cpu}/terraform-docs"

    generate_completions_from_executable(bin/"terraform-docs", "completion")
  end

  test do
    (testpath/"main.tf").write <<~HCL
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
    HCL
    system bin/"terraform-docs", "json", testpath
  end
end
