class TektoncdCli < Formula
  desc "CLI for interacting with TektonCD"
  homepage "https://github.com/tektoncd/cli"
  url "https://github.com/tektoncd/cli/archive/refs/tags/v0.38.1.tar.gz"
  sha256 "46d497871f387335b4b4c339b2d855932f6cb0612d328304c1c755db4e718019"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e4945ec75d7b705c258ce550f458f37e176e058911752f941873f65c243f536c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "220581183442fcc590a05c3111b5901639185d7c985b9bbe156c3e0bf4924fa6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e2a5533c70f89b5e7d4d9b53829e420f7020da240200d0da90c36abf5a2c5d7f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d201441aeb7babf74dc73c98369b67dc82c1f7c2179783b398e34c6ab660906"
    sha256 cellar: :any_skip_relocation, sonoma:         "ef74eae354cd96d7d96fe50eddef268cd2c3ed7b8cbb0470a45fdf3ac0170069"
    sha256 cellar: :any_skip_relocation, ventura:        "6bcc334f5f0dbccffd28e3d8ce0c6e0a5a7962a0489cb4ea37895e859031378c"
    sha256 cellar: :any_skip_relocation, monterey:       "843c8efcebf5623be63974bbbc58896968c5c090b0f9baed32b366ed49a5f848"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "048a4711ab3d8203c2804cc077a694b7cca625f01f8345c25bff110aa0efdd9f"
  end

  depends_on "go" => :build

  def install
    system "make", "bin/tkn"
    bin.install "bin/tkn" => "tkn"

    generate_completions_from_executable(bin/"tkn", "completion", base_name: "tkn")
  end

  test do
    cmd = "#{bin}/tkn pipelinerun describe homebrew-formula"
    io = IO.popen(cmd, err: [:child, :out])
    assert_match "Error: Couldn't get kubeConfiguration namespace", io.read
  end
end
