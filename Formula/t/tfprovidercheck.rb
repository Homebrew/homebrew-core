class Tfprovidercheck < Formula
  desc "CLI to prevent malicious Terraform Providers from being executed"
  homepage "https://github.com/suzuki-shunsuke/tfprovidercheck"
  url "https://github.com/suzuki-shunsuke/tfprovidercheck/archive/refs/tags/v1.0.6.tar.gz"
  sha256 "35b7038242c67864fc969c84e0614e155e8cc4be955226c440b2bba26f3ab116"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/tfprovidercheck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7bd39984bfc74a74c2398c3e26c4bd067eda608951b44c584d085da72d3bb8dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5999fe7f5aa3878e386922f3ae60620217e21281a9eb206d43ea4accd48950f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5999fe7f5aa3878e386922f3ae60620217e21281a9eb206d43ea4accd48950f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5999fe7f5aa3878e386922f3ae60620217e21281a9eb206d43ea4accd48950f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad3c0f23e2e60f0b0415a78664d1c937eda185ecaf2bb1c32b5422ac81d5e24e"
    sha256 cellar: :any_skip_relocation, ventura:       "ad3c0f23e2e60f0b0415a78664d1c937eda185ecaf2bb1c32b5422ac81d5e24e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2564548cfaddf04848f2f34174a0451843a87be03e12cdb2f5c410efba03f297"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea1b43a81af9d43ce3fd5e9aff2f6d642678a533fd867da44c4be37e55d3a7a2"
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
