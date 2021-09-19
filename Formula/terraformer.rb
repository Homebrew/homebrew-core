class Terraformer < Formula
  desc "CLI tool to generate terraform files from existing infrastructure"
  homepage "https://github.com/GoogleCloudPlatform/terraformer"
  url "https://github.com/GoogleCloudPlatform/terraformer/archive/0.8.17.tar.gz"
  sha256 "a14a3e275a585f921c937ee923291733c9cafa19d774aab90535818ad21ccdef"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/terraformer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fb79921417b4b1b600fc3c388e6c079534530a85f74010471ab4a934448cebd4"
    sha256 cellar: :any_skip_relocation, big_sur:       "6f7162524b79c10ca65ab282ac3d5136fe2f551b6f817f2bff33b39b1bdb1f53"
    sha256 cellar: :any_skip_relocation, catalina:      "d7242977949b612a277f6e2e521cc03543e87f8341a57dd0c91f0c8f32bcd142"
    sha256 cellar: :any_skip_relocation, mojave:        "4eb013369d13e3af1be9b663d975935441448b11db93c6a9bc30ae909ace0bfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d874c2f6982b0f1ace309161d07dce00e4cb9ebf16426916e4d30c32c7e227c4"
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
