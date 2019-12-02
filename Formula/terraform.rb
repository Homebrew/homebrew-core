class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v0.12.17.tar.gz"
  sha256 "6f50bfa487ef4fcba7aa6724f85493202e8fa10c86066d0d49ae1cbe7c966bbc"
  head "https://github.com/hashicorp/terraform.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ddb02c7ddf6d33a7acf3e71d5ddcc81e71791f2a63d95a04bcbd89d658102a5c" => :catalina
    sha256 "a0dc81636a6e741ea4ec4fafbd3e4acacce060bce985c3791ecd5191e693f8c5" => :mojave
    sha256 "0d14d96a594d8f35dec15aca851c3f1e6781d27da89191a1e3af74eef76cbc84" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "gox" => :build

  conflicts_with "tfenv", :because => "tfenv symlinks terraform binaries"

  def install
    ENV["GOPATH"] = buildpath
    ENV.prepend_create_path "PATH", buildpath/"bin"

    dir = buildpath/"src/github.com/hashicorp/terraform"
    dir.install buildpath.children - [buildpath/".brew_home"]

    cd dir do
      # v0.6.12 - source contains tests which fail if these environment variables are set locally.
      ENV.delete "AWS_ACCESS_KEY"
      ENV.delete "AWS_SECRET_KEY"

      ENV["XC_OS"] = "darwin"
      ENV["XC_ARCH"] = "amd64"
      system "make", "tools", "bin"

      bin.install "pkg/darwin_amd64/terraform"
      prefix.install_metafiles
    end
  end

  test do
    minimal = testpath/"minimal.tf"
    minimal.write <<~EOS
      variable "aws_region" {
        default = "us-west-2"
      }

      variable "aws_amis" {
        default = {
          eu-west-1 = "ami-b1cf19c6"
          us-east-1 = "ami-de7ab6b6"
          us-west-1 = "ami-3f75767a"
          us-west-2 = "ami-21f78e11"
        }
      }

      # Specify the provider and access details
      provider "aws" {
        access_key = "this_is_a_fake_access"
        secret_key = "this_is_a_fake_secret"
        region     = var.aws_region
      }

      resource "aws_instance" "web" {
        instance_type = "m1.small"
        ami           = var.aws_amis[var.aws_region]
        count         = 4
      }
    EOS
    system "#{bin}/terraform", "init"
    system "#{bin}/terraform", "graph"
  end
end
