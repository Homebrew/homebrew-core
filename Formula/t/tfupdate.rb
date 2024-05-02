class Tfupdate < Formula
  desc "Update version constraints in your Terraform configurations"
  homepage "https://github.com/minamijoyo/tfupdate"
  url "https://github.com/minamijoyo/tfupdate/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "8d03d8843f360edce37b3ba2b5c1c002ede1579bab7a5484341677570c0039ff"
  license "MIT"
  head "https://github.com/minamijoyo/tfupdate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "84dec3fa31784858f13f922edad99b6f6acc5f587e8d36a7779f1121d7fc0a17"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e8bef005503620711f6f5cef3f5dda08353ea0d84fcdbaad9858345ebc324c7c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ca9f228c48cc99b6f022eef6d26fb3ea17137ddfbe1f9d94319c4347b0e14b4"
    sha256 cellar: :any_skip_relocation, sonoma:         "81520953af1ecc9f388af704b1f0ee02189a9b32746a7fcf218c153a365db27d"
    sha256 cellar: :any_skip_relocation, ventura:        "3408722f523bec3233142cf6320ad0dd9cbfe6ee12cff9a780120e3e215afd5e"
    sha256 cellar: :any_skip_relocation, monterey:       "20595f0b38faaf95bdf9ab97c3b065fae6a25149f1536ab558e62aad455d824c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d687a6ecd74f06c43674ebd0d3260c92ae3de62a9832c504bea39e93bebb2f16"
  end

  depends_on "go" => :build

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

    assert_match version.to_s, shell_output(bin/"tfupdate --version")
  end
end
