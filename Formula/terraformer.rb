class Terraformer < Formula
  desc "CLI tool to generate terraform files from existing infrastructure"
  homepage "https://github.com/GoogleCloudPlatform/terraformer"
  url "https://github.com/GoogleCloudPlatform/terraformer/archive/0.8.14.tar.gz"
  sha256 "d6ac4583c4a0d238881fb0d76b761e0ac16c04cdf4c440cba355926e2b22cf59"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/terraformer.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bfa97578206fab28fb072f7615dcd391c4ba69e3e9b902cb490199d999f8f44e"
    sha256 cellar: :any_skip_relocation, big_sur:       "b15c9ce44c82d5d018991adc1e9a2c068cd2dd68ba45ff4551b2e0c31e318792"
    sha256 cellar: :any_skip_relocation, catalina:      "44f560666545dcb9d8ad4bf516a726cd0ac847a9884451ab8890d80bdd2a71bd"
    sha256 cellar: :any_skip_relocation, mojave:        "98701030b0679953f1f053b6ddd4bad6ddb72d1cd2e0895cdfacbe67a586d314"
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
