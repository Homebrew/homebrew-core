class Tfupdate < Formula
  desc "Update version constraints in your Terraform configurations"
  homepage "https://github.com/minamijoyo/tfupdate"
  url "https://github.com/minamijoyo/tfupdate/archive/refs/tags/v0.9.4.tar.gz"
  sha256 "3c30f3e240ae081617ca14fbe006d3fd768149b1b0b5ae944787e9df1b7bbbdf"
  license "MIT"
  head "https://github.com/minamijoyo/tfupdate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "54e137ab80021f4b6670263861576db2ece07d6005cfb971161395124b9dfe75"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54e137ab80021f4b6670263861576db2ece07d6005cfb971161395124b9dfe75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54e137ab80021f4b6670263861576db2ece07d6005cfb971161395124b9dfe75"
    sha256 cellar: :any_skip_relocation, sonoma:        "04f3264e317c2c9f427afc7767fccf79adba8144fd8fba4073afba2f2e24f90a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c42528ba18879ab1e4f979ccf25a1ce066f8db25b01813273d7e1b12ed6c868b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3df17d25feb77ddbf81f811f40664c60091d6345c6b951e49c15befeaa4422b5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
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
