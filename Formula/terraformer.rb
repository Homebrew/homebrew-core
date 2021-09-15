class Terraformer < Formula
  desc "CLI tool to generate terraform files from existing infrastructure"
  homepage "https://github.com/GoogleCloudPlatform/terraformer"
  url "https://github.com/GoogleCloudPlatform/terraformer/archive/0.8.16.tar.gz"
  sha256 "22884dc28a169be3e286486cd9d9a3d719fe71ae1965d2cc27e29aec4adadb71"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/terraformer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9f072b8f1edc429d4fd4460d30a5c44452155990dfd928547f1cea42504a32f2"
    sha256 cellar: :any_skip_relocation, big_sur:       "fb97d2eed304edc133a91eff53f87e4cec35bac1ccc7814b7746eca7d07ba708"
    sha256 cellar: :any_skip_relocation, catalina:      "6a192d733c5b7dba65944589cc20d2a66b8901146e516abd844fe6eb2ad532e4"
    sha256 cellar: :any_skip_relocation, mojave:        "d7b08f233a6bb41166601731200ca692df8e1534d937a4f484ed9a0a7d8a706e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9e4e4c61cfa1619c4301e8355397b7da3c82991339775cb1156c55bfce9eacd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s,
      shell_output("#{bin}/terraformer version")

    assert_match "Available Commands",
      shell_output("#{bin}/terraformer -h")

    assert_match "aaa",
      shell_output("#{bin}/terraformer import google --resources=gcs --projects=aaa 2>&1", 1)
  end
end
