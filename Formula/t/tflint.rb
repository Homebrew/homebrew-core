class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://github.com/terraform-linters/tflint/archive/refs/tags/v0.55.0.tar.gz"
  sha256 "703b62d5333ffb974b634d550fda62821ea369f1409b5e3cd55cd4af465449e3"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9057b79318ad075b2b82149a5edab1843ebc3d4ee2f5c223f04df07dc8e81b0c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9057b79318ad075b2b82149a5edab1843ebc3d4ee2f5c223f04df07dc8e81b0c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9057b79318ad075b2b82149a5edab1843ebc3d4ee2f5c223f04df07dc8e81b0c"
    sha256 cellar: :any_skip_relocation, sonoma:        "79d70362f32df52d4bba4c381db269820d560ea1b1422d9394f69c8a9af6150c"
    sha256 cellar: :any_skip_relocation, ventura:       "b47163cb2780405442beb60deafa133bbce04e50ba3c1b6da815efdb71a35491"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fddc9984148f84cfc20e70c178212b590a2dc03f796ff708acbe69d1ac10175"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"test.tf").write <<~HCL
      terraform {
        required_version = ">= 1.0"

        required_providers {
          aws = {
            source = "hashicorp/aws"
            version = "~> 4"
          }
        }
      }

      provider "aws" {
        region = var.aws_region
      }
    HCL

    # tflint returns exitstatus: 0 (no issues), 2 (errors occurred), 3 (no errors but issues found)
    assert_empty shell_output("#{bin}/tflint --filter=test.tf")
    assert_match version.to_s, shell_output("#{bin}/tflint --version")
  end
end
