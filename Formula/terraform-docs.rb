class TerraformDocs < Formula
  desc "Tool to generate documentation from Terraform modules"
  homepage "https://github.com/segmentio/terraform-docs"
  url "https://github.com/segmentio/terraform-docs/archive/v0.4.5.tar.gz"
  sha256 "78b75d3ba2525b272ae93036465bf3a5137bb259d7f7c106d026529492df2e29"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "268be263298585aa7d3c15231eef8e26487769e82579f69641d21cf619924f17" => :mojave
    sha256 "d41872dfb6e58de57a05f2dafdd8254d5f24c318f7fa992026bf5f95af278a4f" => :high_sierra
    sha256 "96e74e0e07f05e3bc416704e82def271f69f0707936191fec49e582fe4922fa0" => :sierra
    sha256 "507d797efac42fd0ea8785364eda9eb9da2ddae656abca0766b49a90ff11699d" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/segmentio/terraform-docs"
    dir.install buildpath.children

    cd dir do
      system "make", "build-darwin-amd64"
      bin.install "bin/darwin-amd64/terraform-docs"
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
