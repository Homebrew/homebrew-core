class TerraformDocs < Formula
  desc "Tool to generate documentation from Terraform modules"
  homepage "https://github.com/segmentio/terraform-docs"
  url "https://github.com/segmentio/terraform-docs/archive/v0.5.0.tar.gz"
  sha256 "310f4b13585d6ae59687bf20763af5e27930dd30673af24b7297d5fe1fe9df22"

  bottle do
    cellar :any_skip_relocation
    sha256 "b41eeb6f997c60a93bc8ec9bf6ad8206561f98b3d2bd464a03b388dcdf1c4676" => :mojave
    sha256 "9ad7cf9b7bfe86ec62e72dc337bf020c13d48a1f97345988d3f8095ba4a6ec0b" => :high_sierra
    sha256 "5c93638483229ba886dbd760b05f29754c3845ac9a839fc2760bdadae5d7ecd4" => :sierra
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
