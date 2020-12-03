class Terraformer < Formula
  desc "CLI tool to generate terraform files from existing infrastructure"
  homepage "https://github.com/GoogleCloudPlatform/terraformer"
  url "https://github.com/GoogleCloudPlatform/terraformer/archive/0.8.10.tar.gz"
  sha256 "29b99429792542e9911bf49d03545abbcadfba4676ee93e3005a436daab787c2"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/terraformer.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "02d075bae7d6ff08b8f5e7c5461e70b0b6b5ba89b6b881f083888e8fe91df0d3" => :big_sur
    sha256 "e01f6e52c9436afd3c1df1829ab970182f24383b4066c463d0984c481eef75b5" => :catalina
    sha256 "40346e9d8c9a70cec6015fe08af93e76dd4a0e2a313d563cbb0ff2fe87701b5c" => :mojave
    sha256 "a75009ca4799e5ca99b8476250d6f99cc18c869eaec6bd447469726445f8aa12" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
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
