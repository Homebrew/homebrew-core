class Tfprovidercheck < Formula
  desc "CLI to prevent malicious Terraform Providers from being executed"
  homepage "https://github.com/suzuki-shunsuke/tfprovidercheck"
  url "https://github.com/suzuki-shunsuke/tfprovidercheck/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "d6330db7e927dcd89281c2ff8b3545914489a5a09b59e73def8d6525ec8d9596"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/tfprovidercheck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "733969e0b762d900c6e62ad0f0aca34744815a957ab68c2b4e423cea9172f89f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "733969e0b762d900c6e62ad0f0aca34744815a957ab68c2b4e423cea9172f89f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "733969e0b762d900c6e62ad0f0aca34744815a957ab68c2b4e423cea9172f89f"
    sha256 cellar: :any_skip_relocation, sonoma:        "83d0db3fcb8b69b492f658f2ba9f89ce3f8024713ef681e473b6b5db9511d146"
    sha256 cellar: :any_skip_relocation, ventura:       "83d0db3fcb8b69b492f658f2ba9f89ce3f8024713ef681e473b6b5db9511d146"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e0e142366ef11dc5d6dbfbd15af9cb8d218b5a863ae029bb12bb9756fb84de2"
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
