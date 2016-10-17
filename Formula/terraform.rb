require "language/go"

class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v0.7.6.tar.gz"
  sha256 "549a983d248549d5ec4adb3224c27cc3e6fbe87e1654e6851fe6e92d1c953cb1"
  head "https://github.com/hashicorp/terraform.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dc8f15ea8b13741ae3e24c1776860b4e34f0c7a483cb2b158c8076b13a742424" => :sierra
    sha256 "6abe186fd9010b52ce24a7b27fbfd71448752f968e93825eca111f9d4b1688f5" => :el_capitan
    sha256 "c12d2cb75fb0e2df174f32cc6472b37d060a86ee19e649b90e8e0e33a30a7ab6" => :yosemite
  end

  depends_on "go" => :build

  terraform_deps = %w[
    github.com/mitchellh/gox c9740af9c6574448fd48eb30a71f964014c7a837
    github.com/mitchellh/iochan 87b45ffd0e9581375c491fef3d32130bb15c5bd7
    github.com/kisielk/errcheck 9c1292e1c962175f76516859f4a88aabd86dc495
    github.com/kisielk/gotool 5e136deb9b893bbe6c8f23236ff4378b7a8a0dbb
  ]

  terraform_deps.each_slice(2) do |x, y|
    go_resource x do
      url "https://#{x}.git", :revision => y
    end
  end

  go_resource "golang.org/x/tools" do
    url "https://go.googlesource.com/tools.git",
        :revision => "26c35b4dcf6dfcb924e26828ed9f4d028c5ce05a"
  end

  def install
    ENV["GOPATH"] = buildpath
    # For the gox buildtool used by terraform, which doesn't need to
    # get installed permanently
    ENV.append_path "PATH", buildpath

    terrapath = buildpath/"src/github.com/hashicorp/terraform"
    terrapath.install Dir["*"]
    Language::Go.stage_deps resources, buildpath/"src"

    cd "src/github.com/mitchellh/gox" do
      system "go", "build"
      buildpath.install "gox"
    end

    cd "src/golang.org/x/tools/cmd/stringer" do
      ENV.deparallelize { system "go", "build" }
      buildpath.install "stringer"
    end

    cd "src/github.com/kisielk/errcheck" do
      system "go", "build"
      buildpath.install "errcheck"
    end

    cd terrapath do
      # v0.6.12 - source contains tests which fail if these environment variables are set locally.
      ENV.delete "AWS_ACCESS_KEY"
      ENV.delete "AWS_SECRET_KEY"

      # Runs format check and test suite via makefile
      ENV.deparallelize { system "make", "test", "vet" }

      # Generate release binary
      arch = MacOS.prefer_64_bit? ? "amd64" : "386"
      ENV["XC_OS"] = "darwin"
      ENV["XC_ARCH"] = arch
      system "make", "bin"

      # Install release binary
      bin.install "pkg/darwin_#{arch}/terraform"
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
