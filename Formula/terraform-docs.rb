require "language/go"

class TerraformDocs < Formula
  desc "Tool to generate documentation from Terraform modules"
  homepage "https://github.com/segmentio/terraform-docs"
  url "https://github.com/segmentio/terraform-docs/archive/v0.1.0.tar.gz"
  sha256 "47e66da75e179e61cde11a785487b8b05970154153c60fc765ef1f93a376abe2"
  head "https://github.com/segmentio/terraform-docs.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "97799cadd0bd380e3176b6126a9f8b6c314872ab4818428e6f3b1492cd3e219a" => :sierra
    sha256 "d54e4af90588085df0d27d585d88603e9815e772871d614f8025f9a73c28e17a" => :el_capitan
    sha256 "7736b3768981e653d21b9c7faf92161ee3a5c48ceb26acb355071bd121dc0593" => :yosemite
  end

  depends_on "go" => :build

  go_resource "github.com/hashicorp/hcl" do
    url "https://github.com/hashicorp/hcl.git",
        :revision => "630949a3c5fa3c613328e1b8256052cbc2327c9b"
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
      system "go", "build", "-o", "#{bin}/terraform-docs"
      prefix.install_metafiles
    end
  end

  test do
    (testpath/"main.tf").write <<-EOS.undent
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
