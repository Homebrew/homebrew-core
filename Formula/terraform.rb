require "language/go"

class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v0.7.0.tar.gz"
  sha256 "15f8f0589978096152876f5b9ae0853700f52666ff7911e4dad5505e80b12d3b"
  head "https://github.com/hashicorp/terraform.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "52f1fff5b074848687ea4f3c986f017b4c12ba5ad66edd870b34c38470b2c3eb" => :el_capitan
    sha256 "f3bce7c946687d005765e344f1c59e2257c8bfdcf9a71e5d8189d82fadfde632" => :yosemite
    sha256 "cab553ace10ae6ea42a3806cdfe986fa948b4c0bffde0ca1cb1852dc123a5a17" => :mavericks
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
    url "https://go.googlesource.com/tools.git", :revision => "977844c7af2aa555048a19d28e9fe6c392e7b8e9"
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
      system "go", "build"
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
