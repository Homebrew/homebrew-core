class Terraformer < Formula
  desc "CLI tool to generate terraform files from existing infrastructure"
  homepage "https://github.com/GoogleCloudPlatform/terraformer"
  url "https://github.com/GoogleCloudPlatform/terraformer/archive/0.8.10.tar.gz"
  sha256 "29b99429792542e9911bf49d03545abbcadfba4676ee93e3005a436daab787c2"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/terraformer.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8085eba94b70c7ff060955579506bc2a78d8bc8d09c9a321116962f119282936"
    sha256 cellar: :any_skip_relocation, big_sur:       "ceace1a3c90353281ba125f08dbf856b3432c3ad53b451f4ce44f7403391a48a"
    sha256 cellar: :any_skip_relocation, catalina:      "edd0bab50df8cb29b97413468318add8f44f09ad1a762725100f7db167c44fab"
    sha256 cellar: :any_skip_relocation, mojave:        "f0ba34a3a112418298bd25e9e4011b32a7b5fedd7e6b489a44635341c619b04a"
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
