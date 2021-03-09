class Terraformer < Formula
  desc "CLI tool to generate terraform files from existing infrastructure"
  homepage "https://github.com/GoogleCloudPlatform/terraformer"
  url "https://github.com/GoogleCloudPlatform/terraformer/archive/0.8.11.tar.gz"
  sha256 "d3f3710d15fcb75cda82d1c3d51e7ce37eeb059bc22351449d84f3b6d3fa2e43"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/terraformer.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6aec1b6c2f23f3995540e6b5197326ff358c160c82fc68d633ae83d48085faec"
    sha256 cellar: :any_skip_relocation, big_sur:       "52b907bef8df487d250ba1b697ec6098820df904287987f521bf24ad38bd98e5"
    sha256 cellar: :any_skip_relocation, catalina:      "9defda3f8ceeea4e50757a3c4aea1d1f0108152adace35a892c02b018fb247b3"
    sha256 cellar: :any_skip_relocation, mojave:        "2aeb38b63b0c934830b01529c480d8981746ca35c6a7be0a9f5cc5928107f77f"
  end

  depends_on "go" => :build

  # remove in next release
  patch do
    url "https://github.com/chenrui333/terraformer/commit/106ab51.patch?full_index=1"
    sha256 "a222bcee9f1532f6adc75715f83baa9cc4a032cfbc258afca953dfede4ee8649"
  end

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
