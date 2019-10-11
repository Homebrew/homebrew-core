class TerraformDocs < Formula
  desc "Tool to generate documentation from Terraform modules"
  homepage "https://github.com/segmentio/terraform-docs"
  url "https://github.com/segmentio/terraform-docs/archive/v0.6.0.tar.gz"
  sha256 "e52f508f5c47bcb0c9a42307cba564c66ec3a155f336b9a25557e8b0f8facaa3"

  bottle do
    cellar :any_skip_relocation
    sha256 "c0db923a9445496ae2b2e84274bf5db108e59b9b468fff54e155b566853729b0" => :catalina
    sha256 "ec9b27e7c105c18ff9ba7953c18d11a23c32add8fd57dbb91cca31c325994744" => :mojave
    sha256 "e3e88fc9c0a342fce40468b643a964a026b118b4f5a4e9e6f721cc9355923e64" => :high_sierra
    sha256 "a1b0dbfb0b70a888311f4561f5a5fd45e0dee7d9261ea22317867aa166626e50" => :sierra
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
