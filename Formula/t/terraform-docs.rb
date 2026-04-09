class TerraformDocs < Formula
  desc "Tool to generate documentation from Terraform modules"
  homepage "https://terraform-docs.io/"
  url "https://github.com/terraform-docs/terraform-docs/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "336115a1d3a7a55a7295f5768ecc0064c86ed8addc0b0ea27fdfd50b2116dd96"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "49948989b5028270adf2ad3d88dcf25f61359afb7c6f7e02d951f396b6f5dd47"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "002c6b99605ce3ff3890addbdfb0ffec041ab0f4eeca4fc15e5ca1f8598d513f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0db727dedd4739ee79cebe85bc90576f73b17cdc37f30ce62b36f4664eeb27e"
    sha256 cellar: :any_skip_relocation, sonoma:        "6fec6ad830165d5d3bc74cfcb58e279774284d682c19a5cda6fa7d01487539d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "779194cd05c8e3af8bdc554da130fd9c6dcc88871dc28c7f1d0981b1e63fddca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec788f11b5a564344006f7464f1edb3d05093c0bfeed838b5e0da97dd512eb63"
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
