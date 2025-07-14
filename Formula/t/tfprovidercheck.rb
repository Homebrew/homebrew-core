class Tfprovidercheck < Formula
  desc "CLI to prevent malicious Terraform Providers from being executed"
  homepage "https://github.com/suzuki-shunsuke/tfprovidercheck"
  url "https://github.com/suzuki-shunsuke/tfprovidercheck/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "999816d11c9b30a01af4725a118e2e974f6927875fe0d1045ae6e0ab49e95284"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/tfprovidercheck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "677d19930251eac409e75565e6325a56fc7e31014329b3719434de20212c085f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "677d19930251eac409e75565e6325a56fc7e31014329b3719434de20212c085f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "677d19930251eac409e75565e6325a56fc7e31014329b3719434de20212c085f"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f6036c235d4088cbaac59cb2165bad5d2496a0d63ae31586c4396a59f073513"
    sha256 cellar: :any_skip_relocation, ventura:       "0f6036c235d4088cbaac59cb2165bad5d2496a0d63ae31586c4396a59f073513"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f889a0a70843517244b54a61a5de472e7d47313f7aee0fbc9b460d8994a34b5c"
  end

  depends_on "go" => :build
  depends_on "opentofu" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/tfprovidercheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tfprovidercheck -version")

    (testpath/"test.tf").write <<~HCL
      terraform {
        required_version = ">= 1.0"

        required_providers {
          aws = {
            source = "hashicorp/aws"
            version = "~> 5"
          }
        }
      }

      provider "aws" {
        region = var.aws_region
      }
    HCL

    # Only google provider and azurerm provider are allowed
    (testpath/".tfprovidercheck.yaml").write <<~YAML
      providers:
        - name: registry.terraform.io/hashicorp/google
          version: ">= 4.0.0"
        - name: registry.terraform.io/hashicorp/azurerm
    YAML

    system "tofu", "init"
    json_output = shell_output("tofu version -json")
    output = pipe_output("#{bin}/tfprovidercheck 2>&1", json_output, 1)
    assert_match "Terraform Provider is disallowed", output
  end
end
