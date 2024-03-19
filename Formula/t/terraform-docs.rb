class TerraformDocs < Formula
  desc "Tool to generate documentation from Terraform modules"
  homepage "https://github.com/terraform-docs/terraform-docs"
  url "https://github.com/terraform-docs/terraform-docs/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "698537c9cc170f8760cda862d560bfeaa24f2a705bbc70c22a8facbf05a829e0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d889328116661be9128a37ad4f80de05b55ec7921cdd66864c96e93025eac6b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cdd098d37398fd7eb9c7000f29deb790d02997973fc91d5b70e45d86313ed609"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53fab29c6a5a821d41a629da1bdd6daa032c58a1cb882583566c1756d2cc87d3"
    sha256 cellar: :any_skip_relocation, sonoma:         "233fef223a2581394eaa736b1e76748d21a339bb2bf139360ffd9905f4e8caee"
    sha256 cellar: :any_skip_relocation, ventura:        "460a90f5581c93be74d6b6d283b48160dba298dcf67504d9a464e9dd6acea1aa"
    sha256 cellar: :any_skip_relocation, monterey:       "f14f1fa019d6663c0688855b11ad469e3733ffb54c64956f8abefdeeb1661fdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9c5589a89dfefc11e2395ed1edad72bc0760536fd00d7ce30aca84477c1c734"
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
