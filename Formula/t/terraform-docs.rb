class TerraformDocs < Formula
  desc "Tool to generate documentation from Terraform modules"
  homepage "https://github.com/terraform-docs/terraform-docs"
  url "https://github.com/terraform-docs/terraform-docs/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "9341dadb3d45ab8e050d7209c5bd11090e0225b6fc4ea3383d767f08f7e86c6f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c68bd7728ee70a52963bb4739ef5450c76f52b248349e0d6d368da9fdb8695d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc91941af9163d757e1fa24f035ccfb06ac07da89c4b5aed4e1d520401c5b757"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a62a06cb1d58ab43a03859af043a3a41fb2f4c4b8b230315903ef8643387166c"
    sha256 cellar: :any_skip_relocation, sonoma:        "c209d4e5d9ddb7ab31a472d3c4701942332242d29c2c3e30a1e6e0818983d802"
    sha256 cellar: :any_skip_relocation, ventura:       "9e4d6fb02987fe57a6972fcc81659b6a16f6b5418f406c848a14ee8d77e3c6c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73916d978b414105ca9a9d3d264e064b91e90cd43180a6f391372275fa19d563"
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
    system bin/"terraform-docs", "json", testpath
  end
end
