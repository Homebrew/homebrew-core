class TerraformDocs < Formula
  desc "Tool to generate documentation from Terraform modules"
  homepage "https://terraform-docs.io/"
  url "https://github.com/terraform-docs/terraform-docs/archive/refs/tags/v0.25.1.tar.gz"
  sha256 "eef26f765a2193b7f8e4010082a53e0f3ea46ed61b1b61abeb607d75e09caecc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2f22ebc0bd29b30330fbe74d5f0cbbe617d8b3726e501a5e69e9cb0866a8ba05"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2f18874bb6ad48953697c9dd2349b7b8a5524661f89be8f06cc831b864167b36"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e2e5e4b323ef69183982d9f2630e9e2aa45d180f7eca8a41d97b36246a23b314"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4ec6b75d9c2a561929a098f38c3e7ef70946960c54ff72f2dbe5006baa7e6f0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "0e8f8c17e12cbf7cc6b2dab9b578f036ae48ef0f098569fdc9d600185774856e"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
