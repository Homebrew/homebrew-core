class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://github.com/terraform-linters/tflint/archive/refs/tags/v0.62.0.tar.gz"
  sha256 "e3736da82afb3a77037f72b9a01f2d5a60560664ed927426627ef7cfa3356fdd"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "74880fb58c8251cc4cef72ddf8bfdb4eee0910c5d9f480f9c8bbf796c7bd2564"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74880fb58c8251cc4cef72ddf8bfdb4eee0910c5d9f480f9c8bbf796c7bd2564"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74880fb58c8251cc4cef72ddf8bfdb4eee0910c5d9f480f9c8bbf796c7bd2564"
    sha256 cellar: :any_skip_relocation, sonoma:        "19ef66af3e849610ac2664876527efe4783457d8ec64d61d373963aa51204da0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d757d8cce83666f2715232cf720dff1036cd5861081995f9463e660b5c9bdcf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14a28d44e653de43ef61c1a5b9c041c612aa1833965a9767af85d49b5fcfb492"
  end

  depends_on "go" => :build

  # Remove BUSL-derived Terraform source, upstream PR ref, https://github.com/terraform-linters/tflint/pull/2509
  patch do
    url "https://github.com/terraform-linters/tflint/commit/c3268610daeaa768bebcc4df4eea5a80c8f45535.patch?full_index=1"
    sha256 "cc5ed46e8e0543fec04c7e95bccacfaba74ab67a75d170259c48702854e1e84e"
  end
  patch do
    url "https://github.com/terraform-linters/tflint/commit/59b86dc48a1772d8ef49d823e2669f21269668ab.patch?full_index=1"
    sha256 "e89aa2771ab3263fc1fcf2f8d3d9e786b6db34b4487c72bb542dcb7f192d5553"
  end
  patch do
    url "https://github.com/terraform-linters/tflint/commit/151a53130aa6af62e17e06b4d4b9f40df1f873e6.patch?full_index=1"
    sha256 "02a8d7922730386e603c2a29a108915cfe445e9e3b16795f39b13cd1d5b77903"
  end

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
