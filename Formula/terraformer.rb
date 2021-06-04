class Terraformer < Formula
  desc "CLI tool to generate terraform files from existing infrastructure"
  homepage "https://github.com/GoogleCloudPlatform/terraformer"
  url "https://github.com/GoogleCloudPlatform/terraformer/archive/0.8.14.tar.gz"
  sha256 "d6ac4583c4a0d238881fb0d76b761e0ac16c04cdf4c440cba355926e2b22cf59"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/terraformer.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e3b9f996d985e7892f6f43aaeca59d7fcbe6dc00f18400013929015fad53dc99"
    sha256 cellar: :any_skip_relocation, big_sur:       "a65a64ed02e326c9cfbb32c31e4b333c528ca598083b5bcca2b87fff5a5a4cda"
    sha256 cellar: :any_skip_relocation, catalina:      "b86230beefa6cb6077e0c31f35546aacf83a61e7c0111522456889f5ec1178e1"
    sha256 cellar: :any_skip_relocation, mojave:        "dc6e2dab445d01837ede2c7bd679a16348facf840c00226cea2a2e44a9fa2895"
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
