class Tfupdate < Formula
  desc "Update version constraints in your Terraform configurations"
  homepage "https://github.com/minamijoyo/tfupdate"
  url "https://github.com/minamijoyo/tfupdate/archive/v0.7.2.tar.gz"
  sha256 "12b0e8270f7c2d48260a578be656a3487fa51daf4ea1b60de62193fcef604615"
  license "MIT"
  head "https://github.com/minamijoyo/tfupdate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e147333f8c8674e93a18dbd539db69aca5defc1b94e936a7ca68a6247170093"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e147333f8c8674e93a18dbd539db69aca5defc1b94e936a7ca68a6247170093"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1e147333f8c8674e93a18dbd539db69aca5defc1b94e936a7ca68a6247170093"
    sha256 cellar: :any_skip_relocation, ventura:        "5174acb0b28e0640ba6fd2fde3d07267dd19f7bf2132ed9c1ef2bdbf0f7fbcf8"
    sha256 cellar: :any_skip_relocation, monterey:       "5174acb0b28e0640ba6fd2fde3d07267dd19f7bf2132ed9c1ef2bdbf0f7fbcf8"
    sha256 cellar: :any_skip_relocation, big_sur:        "5174acb0b28e0640ba6fd2fde3d07267dd19f7bf2132ed9c1ef2bdbf0f7fbcf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2cf05d712136be4ddd52708cc3c71b80a0a53ce7a82ffdd07e4949791a36dd79"
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
