class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://terramate.io/docs/cli/"
  url "https://github.com/terramate-io/terramate/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "e5df311ea9aa5897541042e51ac37c97c202401dd2a0a09e8cd4f5c07c583387"
  license "MPL-2.0"
  revision 1
  head "https://github.com/terramate-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c51cfef39a4aca1cddf80d7e72ca8c66307d068c697056ff1f403b5f3d7e7f9b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "54fcd4ad1c1efff79cca65084cde80faf6b3422294c25d11594b81c140a678e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42df2a2734501f497b12fe03a10af4bb730d5acf95f3227521e13c8b93624024"
    sha256 cellar: :any_skip_relocation, sonoma:         "68616f2d0a4764a6f3b383825c95ce9ac2ae78da4dac094d9e190781742b70d9"
    sha256 cellar: :any_skip_relocation, ventura:        "74be532a212a438a0b3326036e2fd0fc2b27cd97518c1a4b254eafb652ce7340"
    sha256 cellar: :any_skip_relocation, monterey:       "696d7060c2a9b03645f15542dad32a58d7c45edcf35528d9afb22727c9ce724c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b9f5e4c5762dd36c2cad5e875d07a145b55f7359b172ae90da2caff66faf991"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"terramate", ldflags: "-s -w"), "./cmd/terramate"
    system "go", "build", *std_go_args(output: bin/"terramate-ls", ldflags: "-s -w"), "./cmd/terramate-ls"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terramate version")
    assert_match version.to_s, shell_output("#{bin}/terramate-ls -version")
  end
end
