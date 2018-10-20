require "language/go"

class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v0.11.9.tar.gz"
  sha256 "cf2ecbdc9ea7c5294942f1c633b2871bf2bc620661148bf08546da2d32543784"
  head "https://github.com/hashicorp/terraform.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7847fc5b062dd20ee87bd1f7b327964428c8ec1d055ab01706841c174ad10b91" => :mojave
    sha256 "2a6661129b8be249ec346ea0bbc88f576ed96afad017786e46a9aa0217c4bc3d" => :high_sierra
    sha256 "8cc08e99a8692b4e6a6c25dce236529a583a6b62e99afb5066a12610d405fd58" => :sierra
  end

  depends_on "go" => :build
  depends_on "gox" => :build

  conflicts_with "tfenv", :because => "tfenv symlinks terraform binaries"

  # stringer is a build tool dependency
  go_resource "golang.org/x/tools" do
    url "https://go.googlesource.com/tools.git",
        :branch => "release-branch.go1.11"
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV.prepend_create_path "PATH", buildpath/"bin"

    dir = buildpath/"src/github.com/hashicorp/terraform"
    dir.install buildpath.children - [buildpath/".brew_home"]
    Language::Go.stage_deps resources, buildpath/"src"

    cd "src/golang.org/x/tools/cmd/stringer" do
      system "go", "install"
    end

    cd dir do
      # v0.6.12 - source contains tests which fail if these environment variables are set locally.
      ENV.delete "AWS_ACCESS_KEY"
      ENV.delete "AWS_SECRET_KEY"

      arch = MacOS.prefer_64_bit? ? "amd64" : "386"
      ENV["XC_OS"] = "darwin"
      ENV["XC_ARCH"] = arch
      system "make", "test", "bin"

      bin.install "pkg/darwin_#{arch}/terraform"
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
