class TerraformAT011 < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v0.11.15.tar.gz"
  sha256 "e0f8c5549d45d133f86570c7e5083af3eb1ce64aa0eeeaa5b7c5fa5221cfdd4a"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a9adc546789d09e4b62696954cf28e85dc9e78043950e80a45f77cccbb88a1a6"
    sha256 cellar: :any_skip_relocation, monterey:      "87225e1a86da6d3c2e5bfd075084cb3a4bebc59a4c943113d95db9f01c8f89f1"
    sha256 cellar: :any_skip_relocation, big_sur:       "66f418d06a3fe1d3ad02e6d77815992940fd712f1d8f6e9dcbefd82fec49b75a"
    sha256 cellar: :any_skip_relocation, catalina:      "af2485736328e4ef93a6fbf79d7e6dd4e1c9a01597abd22ee20218d1fe4cc762"
    sha256 cellar: :any_skip_relocation, mojave:        "1b3e7e7126b9410185ed5eae937bb0f814f8eb062d9c09d7e72d91b96d51b228"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67b1bce3e6f2f4a90c9f5416aa065e225805b161f4f32f392f7c71bd9cbb0f40"
  end

  keg_only :versioned_formula

  disable! date: "2022-07-31", because: :unsupported

  depends_on "go@1.16" => :build
  depends_on "gox" => :build
  depends_on arch: :x86_64

  on_linux do
    depends_on "zip" => :build
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV.prepend_create_path "PATH", buildpath/"bin"

    dir = buildpath/"src/github.com/hashicorp/terraform"
    dir.install buildpath.children - [buildpath/".brew_home"]

    cd dir do
      # v0.6.12 - source contains tests which fail if these environment variables are set locally.
      ENV.delete "AWS_ACCESS_KEY"
      ENV.delete "AWS_SECRET_KEY"

      os = OS.kernel_name.downcase
      arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s

      ENV["XC_OS"] = os
      ENV["XC_ARCH"] = arch
      system "go", "mod", "vendor" # Needed for Go 1.14+
      system "make", "tools", "bin"

      bin.install "pkg/#{os}_#{arch}/terraform"
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
