require "language/go"

class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state."
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.1.3.tar.gz"
  sha256 "e7a10b50e8b7fadfc16e0951acb23e9f77b5e7365a8b7a65480fb86997489e49"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "28835356b4c3182eff157c38bf3f12fc162ab806630711b48f0d5a3df79c7db9" => :sierra
    sha256 "cee1b2811027f15d8780c3064c8ae85ee45696d0061d6a496c6abc5005464432" => :el_capitan
    sha256 "562d85fbb52151ad7be4a804efd0f48f64d2b305fa74768f7c22190e21ca9346" => :yosemite
  end

  depends_on "go" => :build
  depends_on "terraform"

  go_resource "github.com/aws/aws-sdk-go" do
    url "https://github.com/aws/aws-sdk-go.git",
      :revision => "1b2abe886743dc2bcc78472bfd30a15dc0a61fb8"
  end

  go_resource "github.com/go-errors/errors" do
    url "https://github.com/go-errors/errors.git",
      :revision => "a41850380601eeb43f4350f7d17c6bbd8944aaf8"
  end

  go_resource "github.com/hashicorp/hcl" do
    url "https://github.com/hashicorp/hcl.git",
      :revision => "6f5bfed9a0a22222fbe4e731ae3481730ba41e93"
  end

  go_resource "github.com/stretchr/testify" do
    url "https://github.com/stretchr/testify.git",
      :revision => "976c720a22c8eb4eb6a0b4348ad85ad12491a506"
  end

  go_resource "github.com/urfave/cli" do
    url "https://github.com/urfave/cli.git",
      :revision => "55f715e28c46073d0e217e2ce8eb46b0b45e3db6"
  end

  def install
    mkdir_p buildpath/"src/github.com/gruntwork-io/"
    ln_s buildpath, buildpath/"src/github.com/gruntwork-io/terragrunt"
    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"
    system "go", "build", "-o", bin/"terragrunt", "-ldflags", "-X main.VERSION=" + version.to_s
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
