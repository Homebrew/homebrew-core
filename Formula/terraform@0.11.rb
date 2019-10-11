class TerraformAT011 < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v0.11.14.tar.gz"
  sha256 "50b75c94c4d3bfe44cfc12c740126747b6b34c014602777154356caa85a783f4"

  bottle do
    cellar :any_skip_relocation
    sha256 "e6db9ebe826e856ff9bb10ffcb8885ce9bf1535ced8c3b477ae48d64c0c99de2" => :catalina
    sha256 "4460e332118c477f7389093d533e63752469973487275f1d656a80974d723888" => :mojave
    sha256 "a7b28af5ba3c9f06614eef3ca71653fbfacc3ff62abbaa75f4c187f996584af8" => :high_sierra
    sha256 "eb5d3500ed06ce55c984e79a317050b4483b25774bf6a77147dfdb2c3746fa25" => :sierra
  end

  keg_only :versioned_formula

  depends_on "go" => :build
  depends_on "gox" => :build

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
      system "make", "tools", "test", "bin"

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
          region = "${var.aws_region}"
      }

      resource "aws_instance" "web" {
        instance_type = "m1.small"
        ami = "${lookup(var.aws_amis, var.aws_region)}"
        count = 4
      }
    EOS
    system "#{bin}/terraform", "init"
    system "#{bin}/terraform", "graph"
  end
end
