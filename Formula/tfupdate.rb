class Tfupdate < Formula
  desc "Update version constraints in your Terraform configurations"
  homepage "https://github.com/minamijoyo/tfupdate"
  url "https://github.com/minamijoyo/tfupdate/archive/v0.6.8.tar.gz"
  sha256 "851068a49540ab8c45fb66aa1107932bd7d9aebfb7dc2e8a8e3ab2dde845624a"
  license "MIT"
  head "https://github.com/minamijoyo/tfupdate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7955306361195a2c069b0968a9cd37e43e0db38dc61a70a6794ca37ee0f7f0ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7955306361195a2c069b0968a9cd37e43e0db38dc61a70a6794ca37ee0f7f0ad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7955306361195a2c069b0968a9cd37e43e0db38dc61a70a6794ca37ee0f7f0ad"
    sha256 cellar: :any_skip_relocation, ventura:        "9efde569a58f1e8a35eaab9f4e3b53acbf8b6e8bc44add63c8e518d973ddfc75"
    sha256 cellar: :any_skip_relocation, monterey:       "9efde569a58f1e8a35eaab9f4e3b53acbf8b6e8bc44add63c8e518d973ddfc75"
    sha256 cellar: :any_skip_relocation, big_sur:        "9efde569a58f1e8a35eaab9f4e3b53acbf8b6e8bc44add63c8e518d973ddfc75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8048e1c6279a55200224db0a3a55a07a75fc0710d6f0ce7adcee41c64438a7b5"
  end

  depends_on "go" => :build
  depends_on "terraform" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"provider.tf").write <<~EOS
      provider "aws" {
        version = "2.39.0"
      }
    EOS

    system bin/"tfupdate", "provider", "aws", "-v", "2.40.0", testpath/"provider.tf"
    assert_match "2.40.0", File.read(testpath/"provider.tf")

    # list the most recent 5 releases
    assert_match Formula["terraform"].version.to_s, shell_output(bin/"tfupdate release list -n 5 hashicorp/terraform")

    assert_match version.to_s, shell_output(bin/"tfupdate --version")
  end
end
