class TerraformDocs < Formula
  desc "Tool to generate documentation from Terraform modules"
  homepage "https://terraform-docs.io/"
  url "https://github.com/terraform-docs/terraform-docs/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "880c9a174ea71a87cc42ba5228bdc800841afa3b2c18e986a4ae13ea767e0940"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af19d1faefaf680609418e7bbc567f7054f17fb43426442f76b11b10ed813215"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19a9ab9a7727151d2598c487d84980894587da637d1457962a1653fe748455af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b5bc5f0c6f0295b07dd316222d790e1b1dbab37b6cb294177606b0cde4cc894"
    sha256 cellar: :any_skip_relocation, sonoma:        "9543364f640bcc242f36def029ab283d0044b903d14329a7e49cbb446cfcc64c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56f4cdde669690deeb326dcbb543b087f70aa7a284a0b601dc08ed08661a0e8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9546f48eb996ec23376ea4a142631b26371a5b2dcae155ca574ab5f607c8fd0"
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
