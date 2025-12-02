class Zns < Formula
  desc "CLI tool for querying DNS records with readable, colored output"
  homepage "https://github.com/znscli/zns"
  url "https://github.com/znscli/zns/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "ae3aebc174ee839168b6b91f37a082d3efe275202927aa87743b04b87a8d13d8"
  license "MIT"
  head "https://github.com/znscli/zns.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7cc41244bcfbf7df964ebcb5ac7171abbeee3e9935107ed37e008cfc1ec1103b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7cc41244bcfbf7df964ebcb5ac7171abbeee3e9935107ed37e008cfc1ec1103b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7cc41244bcfbf7df964ebcb5ac7171abbeee3e9935107ed37e008cfc1ec1103b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7cc41244bcfbf7df964ebcb5ac7171abbeee3e9935107ed37e008cfc1ec1103b"
    sha256 cellar: :any_skip_relocation, sonoma:        "039f992e91d42aab450a339cd8ab8426f7f3873d423b06fac2a14a13ff9cd882"
    sha256 cellar: :any_skip_relocation, ventura:       "039f992e91d42aab450a339cd8ab8426f7f3873d423b06fac2a14a13ff9cd882"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8739ac54fb0abed262d78c9bbbe2dfed5af8bb48539439a6ffb9a400ef8a4713"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7497871ad502dca1485cce5d0e5654bd2e989080dd6914ba2efe880df81a707f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/znscli/zns/cmd.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zns --version")
    assert_match "a.iana-servers.net.", shell_output("#{bin}/zns example.com -q NS --server 1.1.1.1")
  end
end
