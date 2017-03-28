require "language/go"

class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v0.9.1.tar.gz"
  sha256 "af8402ce84b85a16cfac3796c1f30f229a0d0e93585c6c618af2f25aae067e65"
  revision 1
  head "https://github.com/hashicorp/terraform.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5c6ca950dffbd9456c9cdac4113a2643377cdec3fc3ed720568dcb8dd71bbb2e" => :sierra
    sha256 "897de40afdd87c3f283f66f410ff2c17dc2cf2ce58b8672de5335e7b40c8e9f3" => :el_capitan
    sha256 "f22d3b34455c7e34201be5b487d85336bee7d9e7d1e432989a3bc708b4c31f73" => :yosemite
  end

  depends_on "go" => :build

  conflicts_with "tfenv", :because => "tfenv symlinks terraform binaries"

  go_resource "github.com/mitchellh/gox" do
    url "https://github.com/mitchellh/gox.git",
        :revision => "c9740af9c6574448fd48eb30a71f964014c7a837"
  end

  go_resource "github.com/mitchellh/iochan" do
    url "https://github.com/mitchellh/iochan.git",
        :revision => "87b45ffd0e9581375c491fef3d32130bb15c5bd7"
  end

  go_resource "github.com/kisielk/errcheck" do
    url "https://github.com/kisielk/errcheck.git",
        :revision => "9c1292e1c962175f76516859f4a88aabd86dc495"
  end

  go_resource "github.com/kisielk/gotool" do
    url "https://github.com/kisielk/gotool.git",
        :revision => "5e136deb9b893bbe6c8f23236ff4378b7a8a0dbb"
  end

  go_resource "golang.org/x/tools" do
    url "https://go.googlesource.com/tools.git",
        :revision => "26c35b4dcf6dfcb924e26828ed9f4d028c5ce05a"
  end

  # vet error (please remove after next version release)
  # upstream issue: https://github.com/hashicorp/terraform/pull/12839
  patch do
    url "https://github.com/hashicorp/terraform/commit/bc4a3d62a59dc14c11a8546cc4e7e32ec7553fab.patch"
    sha256 "ac312a0cc46833a45ef51d56961bdc7c7d60cb8c709ee305f476e4b68e8685e5"
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV.prepend_create_path "PATH", buildpath/"bin"

    dir = buildpath/"src/github.com/hashicorp/terraform"
    dir.install buildpath.children - [buildpath/".brew_home"]
    Language::Go.stage_deps resources, buildpath/"src"

    %w[src/github.com/mitchellh/gox src/golang.org/x/tools/cmd/stringer
       src/github.com/kisielk/errcheck].each do |path|
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
