class TerraformDocs < Formula
  desc "Tool to generate documentation from Terraform modules"
  homepage "https://terraform-docs.io/"
  url "https://github.com/terraform-docs/terraform-docs/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "793ad60be207292b9f27664d5c73bd75512e7a5e458b0fe2daa872b5ad46d6a9"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7fe8d99487a213818abfba231555ba8fb1e8fb91349e681b497e81907bb9a3f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61839fb6a203ccc38e8c8f6d17eac0180ca754dfee8acb2c22caf36462445270"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "077a2f758437da21b2261542136cce7ef0e3a25a49bc9302881656c80710000c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b9846110ee3a9ab3686bd96e381e651ed83816224c476540218c289a72c2f2ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "b5dcc69027cbb34191b24b89b2364c79f41bfdc710a9ed97313305df0b840ea8"
    sha256 cellar: :any_skip_relocation, ventura:       "d81ad6cb5d8ecd1c47f261ccfe5e997944e5d79bbf65b4b2967a0181e3e8b1e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "195ef180318ab81e1e834597c845df5c9a71f792bb2d6037f77f766cdb6b9100"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ed822006985f68806fc9ad31c591f314252ab941d939568a40096989fcecb36"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    cpu = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    os = OS.kernel_name.downcase

    bin.install "bin/#{os}-#{cpu}/terraform-docs"

    generate_completions_from_executable(bin/"terraform-docs", "completion", shells: [:bash, :zsh])
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
