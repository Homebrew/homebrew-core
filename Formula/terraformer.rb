class Terraformer < Formula
  desc "CLI tool to generate terraform files from existing infrastructure"
  homepage "https://github.com/GoogleCloudPlatform/terraformer"
  url "https://github.com/GoogleCloudPlatform/terraformer/archive/0.8.18.tar.gz"
  sha256 "bb4f000fda19917dcb67e00ade048366bafc9f928da45f3d32758fec372b28cf"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/terraformer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5072433e56f6733a7b5e155d5d96462ac65affad4797630299ad12afc21ff04c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "af33c9e922c7b28762fa3c6140978bd6ee8382c69d8923920eb9a5c9110d49d2"
    sha256 cellar: :any_skip_relocation, monterey:       "58aae7baefdc9a45ea133e219c9cf05e53793bf1b872255e720e72f7fe3fc868"
    sha256 cellar: :any_skip_relocation, big_sur:        "1541fa358639322c5ffd323e294fce0d1fde0ea623f39b6eaedd6fa60995a47a"
    sha256 cellar: :any_skip_relocation, catalina:       "58727f550e40191baf766b3e7141c038ac42e9025b2423392932e687a5738fb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4405e1fb31770e11c684c8cd1d3ef4ad1945326d54c83254198aa77e79131d3"
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
