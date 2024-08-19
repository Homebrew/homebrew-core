class TerraformDocs < Formula
  desc "Tool to generate documentation from Terraform modules"
  homepage "https://github.com/terraform-docs/terraform-docs"
  url "https://github.com/terraform-docs/terraform-docs/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "ed4c51a8f8be8f9cf5117331005b200d807f362604447ddeb6781c744e5f4743"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "68cf1b1fd3b7d2319ef71cc52d6c2451f24f83cb8a84e5c5f8744f2250e8ddb7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7d965fcf82e94ec71374efd71f2017e40395136b8302f316c7bc837b96c1e148"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "876c0662c9d6443a04f8a1144ca2ffd6c9fd0d2200b70d0e8a993191ef2c57a2"
    sha256 cellar: :any_skip_relocation, sonoma:         "d09f055d80890bea3fe6ea50acc910dfce0fad93fc6dc01bcf31586419dc3c84"
    sha256 cellar: :any_skip_relocation, ventura:        "b84693b845e45a61debfb2b28e173722d9912726cfc5549d3cc7dfeedbd9f3c8"
    sha256 cellar: :any_skip_relocation, monterey:       "639164d4790ec82ba8bb9e68fbdca92174f244d9426266a2f5499eff7eabeb18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd7a2f2f7492b986deeda404c41568d14bec7d37ccf240f4b4652ee518564f05"
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
