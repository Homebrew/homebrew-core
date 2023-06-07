class TerraformDocs < Formula
  desc "Tool to generate documentation from Terraform modules"
  homepage "https://github.com/terraform-docs/terraform-docs"
  url "https://github.com/terraform-docs/terraform-docs/archive/v0.16.0.tar.gz"
  sha256 "e370fd106ca74caebc8632834cc28412a3a6a160952392da71f213515bba2085"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "668f0822b31d0bff7505929546b63d2402cf5dd827798a0fe7e74b5e7252a0cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6fddc004ce8b2d291af3be852071361f4c08c9c15e9b427c63eded1f86cf989b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ee06989a498ca1ee3f94fade88adcfc96d4d6d833b6ea3582bb6aaeda15b5279"
    sha256 cellar: :any_skip_relocation, ventura:        "d90a3a70220aca39b2be6df347ae77f051ea697be474bb0283289cd9f9108fce"
    sha256 cellar: :any_skip_relocation, monterey:       "35bbce206ca1a1ee152ac0248f21016de5465076d56bd625043a38a02e7358d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "ec8e73ce93f2e026c762c2a27809e964c81300d4555889ca54c7aa490ab986cc"
    sha256 cellar: :any_skip_relocation, catalina:       "c6d9da269af431f70956ea73cbf2a5d6ac98418a5cabc7b40d85f01c3f228ab4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa3db94146d5bae501b11fc6e35c27ca8468ccc32ebc4c60cd36fc1c7fa667b1"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    cpu = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    os = OS.kernel_name.downcase

    bin.install "bin/#{os}-#{cpu}/terraform-docs"
    prefix.install_metafiles

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
    system "#{bin}/terraform-docs", "json", testpath
  end
end
