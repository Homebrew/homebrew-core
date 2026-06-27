class Tfprovidercheck < Formula
  desc "CLI to prevent malicious Terraform Providers from being executed"
  homepage "https://github.com/suzuki-shunsuke/tfprovidercheck"
  url "https://github.com/suzuki-shunsuke/tfprovidercheck/archive/refs/tags/v1.0.7.tar.gz"
  sha256 "99dddd4317b99c3f304ed206b68de5c13840995dd04218968fe693ec77d20cd2"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/tfprovidercheck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "427a2a1015f2145bd56bfab2f7e55da6e9dd51d269f52865b74332595bc17d1e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "427a2a1015f2145bd56bfab2f7e55da6e9dd51d269f52865b74332595bc17d1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "427a2a1015f2145bd56bfab2f7e55da6e9dd51d269f52865b74332595bc17d1e"
    sha256 cellar: :any_skip_relocation, sonoma:        "4cbaf50f5a3e8dc17c9a1afe95c18337234b75e478723f2511ff6152617723f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b8f7a9fb706c0b91832695220d4afb0db43549beaae7707ceeebfc53050886e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31a2633383d7a927d45d1591203d5781cc6e0e5681e6a3d5155a48a1837368fa"
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
