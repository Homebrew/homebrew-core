require "language/go"

class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v0.11.4.tar.gz"
  sha256 "64bd59212e0fed24cacbc9c9b5cbfb0bb5e035e9f19e75d308f8738b662f08bc"
  head "https://github.com/hashicorp/terraform.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a218b3bf86125735cd7e3e0f11ac257efc63e8762f06283674f9ec15caa2e6b0" => :high_sierra
    sha256 "8d42d2a99ca5b5e2fa1190ecbaceec13bd359891227a9f8563e8bea283ccaa18" => :sierra
    sha256 "a6473ea9e7d3a648767327e5f184c9f096734c9347b8e81e61f276368be10818" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "gox" => :build

  conflicts_with "tfenv", :because => "tfenv symlinks terraform binaries"

  # stringer is a build tool dependency
  go_resource "golang.org/x/tools" do
    url "https://go.googlesource.com/tools.git",
        :branch => "release-branch.go1.9"
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
      zsh_completion.install "contrib/zsh-completion/_terraform"
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
