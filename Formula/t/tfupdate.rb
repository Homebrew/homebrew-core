class Tfupdate < Formula
  desc "Update version constraints in your Terraform configurations"
  homepage "https://github.com/minamijoyo/tfupdate"
  url "https://github.com/minamijoyo/tfupdate/archive/refs/tags/v0.10.3.tar.gz"
  sha256 "66d0aebdbd41c82d39edb6f2b241bb194fe7a03c162a555c6baa8f8ab7c794f6"
  license "MIT"
  head "https://github.com/minamijoyo/tfupdate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1a60c2d0662fad98e211810f06420391d9135f71e0500300235ce3ce02066cba"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1a60c2d0662fad98e211810f06420391d9135f71e0500300235ce3ce02066cba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1a60c2d0662fad98e211810f06420391d9135f71e0500300235ce3ce02066cba"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c30a1b75e3c10f15ba647c050403f0ccba41a4b3c7bfaff2d35eae262e50015f"
    sha256 cellar: :any,                 x86_64_linux:      "92c4bdd089aceb6d70167eea5000d87bc0481958a9b805b315180ca2ad0c034a"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args
  end

  test do
    (testpath/"provider.tf").write <<~HCL
      provider "aws" {
        version = "2.39.0"
      }
    HCL

    system bin/"tfupdate", "provider", "aws", "-v", "2.40.0", testpath/"provider.tf"
    assert_match "2.40.0", File.read(testpath/"provider.tf")

    assert_match version.to_s, shell_output("#{bin}/tfupdate --version")
  end
end
