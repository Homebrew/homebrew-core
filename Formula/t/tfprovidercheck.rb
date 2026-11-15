class Tfprovidercheck < Formula
  desc "CLI to prevent malicious Terraform Providers from being executed"
  homepage "https://github.com/suzuki-shunsuke/tfprovidercheck"
  url "https://github.com/suzuki-shunsuke/tfprovidercheck/archive/refs/tags/v1.0.8.tar.gz"
  sha256 "a65ad63250b2640d4891294f804a4dfdf90ffae06491b1172437c1f1c97b266a"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/tfprovidercheck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7273c1d9ab1294a7c1491186878b1c783ca5f4d62c909fe59505ba22ce382cb1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7273c1d9ab1294a7c1491186878b1c783ca5f4d62c909fe59505ba22ce382cb1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7273c1d9ab1294a7c1491186878b1c783ca5f4d62c909fe59505ba22ce382cb1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b7a43fb52f9890ffd82363b13dbc86d28b43e77d87437d89cd3bd1ef7d5ac559"
    sha256 cellar: :any,                 x86_64_linux:      "8ea1e5f6e157086867c29665aeb62b7854d7971fdae39ab6cf8964b6cd671005"
  end

  depends_on "go" => :build
  depends_on "opentofu" => :test

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/tfprovidercheck"
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
