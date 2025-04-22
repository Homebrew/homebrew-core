class TektoncdCli < Formula
  desc "CLI for interacting with TektonCD"
  homepage "https://github.com/tektoncd/cli"
  url "https://github.com/tektoncd/cli/archive/refs/tags/v0.40.0.tar.gz"
  sha256 "682f56835596b0d55c72bf1e393ea5b9a16d338b40799a546a908b794615901f"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f007aff9cfb81337f1017cb9648a9bf494ce329a8e6240d32d424ac0c23fea55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2916dedf40f334b4aeabc62c417167b4b6223e1df2cea55f31650b8684806f3b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d3c8a69268bb37ec5beb0716e7cee2a3c3dff358ef2583b2c35e0bd65c4a37df"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d70361c241a222d0f109c16d1eb2a6c9815105a18811434971f3024f099e8c2"
    sha256 cellar: :any_skip_relocation, ventura:       "7bdd8d402587a5c373f7f59ef5a14384e3b58fa8fa875c810e4186464909c3a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b91cbfdce7d57cac87b37af5fdce93acba738a2c8a9d5ded7773500b7723868f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "794a9bf68544c01e3bf6d55b24146dd5751c739af235318de23408dc85c5e327"
  end

  depends_on "go" => :build

  def install
    system "make", "bin/tkn"
    bin.install "bin/tkn" => "tkn"

    generate_completions_from_executable(bin/"tkn", "completion")
  end

  test do
    output = shell_output("#{bin}/tkn pipelinerun describe homebrew-formula 2>&1", 1)
    assert_match "Error: Couldn't get kubeConfiguration namespace", output
  end
end
