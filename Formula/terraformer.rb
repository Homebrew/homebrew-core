class Terraformer < Formula
  desc "CLI tool to generate terraform files from existing infrastructure"
  homepage "https://github.com/GoogleCloudPlatform/terraformer"
  url "https://github.com/GoogleCloudPlatform/terraformer/archive/0.8.12.tar.gz"
  sha256 "d60ffd0ec8c852cfea85c8e4f5274403f2f1049a5c758e45060c45d9544f05a8"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/terraformer.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bd592cf821c142e2ecb4272e1457b00a977d2e04f79725a8eabc4abbb50c0e8d"
    sha256 cellar: :any_skip_relocation, big_sur:       "91ee452cd6840a30bf3d1e5d414784143cafb1f38d887c0d31f43631a1b23ece"
    sha256 cellar: :any_skip_relocation, catalina:      "fd67630a28f7cd19aaedd3775599a9830310f5082e538c263d00d5435367eefb"
    sha256 cellar: :any_skip_relocation, mojave:        "df423299033d98864f1d203136c0804216941a7b2d2f5e6da8cf5856eb383b04"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w"
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
