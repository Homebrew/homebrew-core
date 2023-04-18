class Tfupdate < Formula
  desc "Update version constraints in your Terraform configurations"
  homepage "https://github.com/minamijoyo/tfupdate"
  url "https://github.com/minamijoyo/tfupdate/archive/v0.6.7.tar.gz"
  sha256 "f62a8748ffef97c1a7697d76bb2e76b79a9254d957f799b1e15413b946b4ee33"
  license "MIT"
  head "https://github.com/minamijoyo/tfupdate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4fff4e93c611eab2c0d26df8ddeb5f242c81e0104560f020f51817feba050353"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19156a71dec1f2d6c17fae3a9b6c45671070f855e71e53e75a74a6e376229a35"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "41ec805691e10a283cfb578414ab135264633afa0cce319708d8501f9bc5f6b2"
    sha256 cellar: :any_skip_relocation, ventura:        "f80b7286c4b38ff1b9c257a4c70d51ba935b3e1e60acaaa9448bbe687f2c3618"
    sha256 cellar: :any_skip_relocation, monterey:       "0acb42223d76867e3a64145bbe9b824b95bdefc09bf9703581d73b060d109d57"
    sha256 cellar: :any_skip_relocation, big_sur:        "d6715e6cdc7737354e444cfc1bdae78a5f54017979744ef7a18e79ed807e056f"
    sha256 cellar: :any_skip_relocation, catalina:       "c6f9987eeb7eac917a496a02c10bbee9c087481b8a94d936cf18febe287165f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16f7d129f24e6b4ed306b5e045678f090afddf61d12c13ccddfdd2c283ca25d7"
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
