class Tfupdate < Formula
  desc "Update version constraints in your Terraform configurations"
  homepage "https://github.com/minamijoyo/tfupdate"
  url "https://github.com/minamijoyo/tfupdate/archive/v0.6.6.tar.gz"
  sha256 "1abdb562a21d98e7947f08e430786210f2abe828debdbd0a0e8c5b986cebe4fc"
  license "MIT"
  head "https://github.com/minamijoyo/tfupdate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "90cfbf60973659668f952827346f83507013cd7fc54e2fb10358a1e2b98264b7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9f44621666f39b31247804738f33d816973b750718d8eec146897ba85891f0ee"
    sha256 cellar: :any_skip_relocation, monterey:       "3c44658fd4b614f700441d390ebd49c68aa4f13f93e122ee8d44d74c18cc63a5"
    sha256 cellar: :any_skip_relocation, big_sur:        "5ea608eec6749ae0366e7e61105b71bf72defbcfbc6ffdcf4a982f0f159f41a7"
    sha256 cellar: :any_skip_relocation, catalina:       "b7d33add107ccf53cc726bb188a4e59b7608bd3cadf1a8483a69db8ca611d1d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7101a971342a73e037d191c2f60572c01d2d8f993a5dc1a2001de078b9374518"
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
