require "language/go"

class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v0.6.16.tar.gz"
  sha256 "c84bae32a170d993982de9c537eac74f70601e7a667dc2ea9803b86e04b1221d"
  head "https://github.com/hashicorp/terraform.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "634e81edcc7b8a23a45701a89a7674d0e42029052a0a6773ded8fec0fc85e34d" => :el_capitan
    sha256 "19f698b20da37ec5256f9446f03f78000fc4d1719540580abb4c9b6e3b535227" => :yosemite
    sha256 "c72e135740cbf6cbddfaf27bda8b3c9935e787ca2e6f11d03566477e50899b1b" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"bin"
    ENV.append_path "PATH", buildpath/"bin"

    terrapath = buildpath/"src/github.com/hashicorp/terraform"
    terrapath.install Dir["*"]

    cd terrapath do
      ENV["XC_OS"] = "darwin"
      ENV["XC_ARCH"] = MacOS.prefer_64_bit? ? "amd64" : "386"
      system "make", "bin"
      bin.install Dir["bin/*"]
      zsh_completion.install "contrib/zsh-completion/_terraform"
    end
  end

  test do
    minimal = testpath/"minimal.tf"
    minimal.write <<-EOS.undent
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
    system "#{bin}/terraform", "graph", testpath
  end
end
