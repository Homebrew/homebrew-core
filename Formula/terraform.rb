require "language/go"

class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v0.7.3.tar.gz"
  sha256 "dbbb755236af0ebd98ea892f12b0780731bab650583db3626129b9ec399352ce"
  head "https://github.com/hashicorp/terraform.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a8dc2c8296fac4b36f92313f48c32d233fb1ab98201e2e7e8c30b078bcfc8d87" => :sierra
    sha256 "86e5d9046c2fb3d61d6da690890284098e4e93fc696debcca69c6f12e8fb25dc" => :el_capitan
    sha256 "413255c2c05b6e9db6abc1a8551be51942adef314eafcdc8742b0ad0aec480df" => :yosemite
    sha256 "345117ece6408a1696cfe128bee2010cfeaf67e274f7661d74b52387d2c30598" => :mavericks
  end

  depends_on "go" => :build

  terraform_deps = %w[
    github.com/mitchellh/gox 770c39f64e66797aa46b70ea953ff57d41658e40
    github.com/mitchellh/iochan 87b45ffd0e9581375c491fef3d32130bb15c5bd7
  ]

  terraform_deps.each_slice(2) do |x, y|
    go_resource x do
      url "https://#{x}.git", :revision => y
    end
  end

  go_resource "golang.org/x/tools" do
    url "https://go.googlesource.com/tools.git",
        :revision => "977844c7af2aa555048a19d28e9fe6c392e7b8e9"
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

    cd terrapath do
      # v0.6.12 - source contains tests which fail if these environment variables are set locally.
      ENV.delete "AWS_ACCESS_KEY"
      ENV.delete "AWS_SECRET_KEY"

      terraform_files = `go list ./...`.lines.map { |f| f.strip unless f.include? "/vendor/" }.compact
      system "go", "test", *terraform_files

      mkdir "bin"
      arch = MacOS.prefer_64_bit? ? "amd64" : "386"
      system "gox",
        "-arch", arch,
        "-os", "darwin",
        "-output", "bin/terraform-{{.Dir}}", *terraform_files
      bin.install "bin/terraform-terraform" => "terraform"
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
