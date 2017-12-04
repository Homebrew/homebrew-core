require "language/go"

class TerraformDocs < Formula
  desc "Tool to generate documentation from Terraform modules"
  homepage "https://github.com/segmentio/terraform-docs"
  url "https://github.com/segmentio/terraform-docs/archive/v0.3.0.tar.gz"
  sha256 "0cfac8ed50a6ba458ec5177e493fd8adc05395f3d9ba79504dc33ce6e5733fcd"
  head "https://github.com/segmentio/terraform-docs.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d41872dfb6e58de57a05f2dafdd8254d5f24c318f7fa992026bf5f95af278a4f" => :high_sierra
    sha256 "96e74e0e07f05e3bc416704e82def271f69f0707936191fec49e582fe4922fa0" => :sierra
    sha256 "507d797efac42fd0ea8785364eda9eb9da2ddae656abca0766b49a90ff11699d" => :el_capitan
  end

  depends_on "go" => :build

  go_resource "github.com/hashicorp/hcl" do
    url "https://github.com/hashicorp/hcl.git",
        :revision => "23c074d0eceb2b8a5bfdbb271ab780cde70f05a8"
  end

  go_resource "github.com/tj/docopt" do
    url "https://github.com/tj/docopt.git",
        :revision => "c8470e45692f168e8b380c5d625327e756d7d0a9"
  end

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/segmentio/terraform-docs").install buildpath.children
    Language::Go.stage_deps resources, buildpath/"src"
    cd "src/github.com/segmentio/terraform-docs" do
      system "go", "build", "-o", "#{bin}/terraform-docs", "-ldflags",
             "-X main.version=#{version}"
      prefix.install_metafiles
    end
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
      *
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
