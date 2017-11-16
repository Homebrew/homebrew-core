require "language/go"

class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v0.11.0.tar.gz"
  sha256 "2625ab24b71ccb8b9e1cf8794c3d3cd147313768066103fb970d58fa6a0a65fe"
  head "https://github.com/hashicorp/terraform.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "46bdd747cbc28001e7a2a7891a20661a8dfec7c9726f0ceb0c3543bc70ce52e4" => :high_sierra
    sha256 "9f85a9778638230e1dff1ec9c869cdb58d6a07de2c00edc11f15863cee5c322a" => :sierra
    sha256 "79e191a80065ea1ae7dba9836e4e8aaaf4edfb8a734ecff87b6cc446f388b6dc" => :el_capitan
  end

  depends_on "go" => :build

  conflicts_with "tfenv", :because => "tfenv symlinks terraform binaries"

  # gox is a build tool dependency
  go_resource "github.com/mitchellh/gox" do
    url "https://github.com/mitchellh/gox.git",
        :revision => "c9740af9c6574448fd48eb30a71f964014c7a837"
  end

  # iochan is a build dependency of gox
  go_resource "github.com/mitchellh/iochan" do
    url "https://github.com/mitchellh/iochan.git",
        :revision => "87b45ffd0e9581375c491fef3d32130bb15c5bd7"
  end

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

    %w[src/github.com/mitchellh/gox
       src/golang.org/x/tools/cmd/stringer].each do |path|
      cd(path) { system "go", "install" }
    end

    cd dir do
      # v0.6.12 - source contains tests which fail if these environment variables are set locally.
      ENV.delete "AWS_ACCESS_KEY"
      ENV.delete "AWS_SECRET_KEY"

      arch = MacOS.prefer_64_bit? ? "amd64" : "386"
      ENV["XC_OS"] = "darwin"
      ENV["XC_ARCH"] = arch
      system "make", "test", "vet", "bin"

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
