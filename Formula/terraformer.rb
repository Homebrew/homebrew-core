class Terraformer < Formula
  desc "CLI tool to generate terraform files from existing infrastructure"
  homepage "https://github.com/GoogleCloudPlatform/terraformer"
  url "https://github.com/GoogleCloudPlatform/terraformer/archive/0.8.11.tar.gz"
  sha256 "d3f3710d15fcb75cda82d1c3d51e7ce37eeb059bc22351449d84f3b6d3fa2e43"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/terraformer.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8085eba94b70c7ff060955579506bc2a78d8bc8d09c9a321116962f119282936"
    sha256 cellar: :any_skip_relocation, big_sur:       "ceace1a3c90353281ba125f08dbf856b3432c3ad53b451f4ce44f7403391a48a"
    sha256 cellar: :any_skip_relocation, catalina:      "edd0bab50df8cb29b97413468318add8f44f09ad1a762725100f7db167c44fab"
    sha256 cellar: :any_skip_relocation, mojave:        "f0ba34a3a112418298bd25e9e4011b32a7b5fedd7e6b489a44635341c619b04a"
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
