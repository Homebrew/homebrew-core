require "language/go"

class TerraformDocs < Formula
  desc "Tool to generate documentation from Terraform modules"
  homepage "https://github.com/segmentio/terraform-docs"
  url "https://github.com/segmentio/terraform-docs/archive/v0.2.0.tar.gz"
  sha256 "8f3ed47cfedde0a6e4ab8826b1d87009d06b7c04161363490b0a6c157473a146"
  head "https://github.com/segmentio/terraform-docs.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8b9fd4260918f3dfa94c3e174e03dd22429ddd54c032486a40c6e0a39ce1bd3d" => :high_sierra
    sha256 "b257ed5c8902d1866fdfdd54450a573cf794b9dab7c6b46b53bfcfc2e194d6b5" => :sierra
    sha256 "2f837ebdd13cc095db958dbf3dcdac8fe12f4fc2bbba14e41035b791c1d5c950" => :el_capitan
    sha256 "8a79d91615019ba653775e465abf80c5856f9779b7a89ce29987a10ae57a7223" => :yosemite
  end

  depends_on "go" => :build

  go_resource "github.com/hashicorp/hcl" do
    url "https://github.com/hashicorp/hcl.git",
        :revision => "392dba7d905ed5d04a5794ba89f558b27e2ba1ca"
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
