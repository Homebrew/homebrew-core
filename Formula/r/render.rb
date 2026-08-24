class Render < Formula
  desc "Command-line interface for Render"
  homepage "https://render.com/docs/cli"
  url "https://github.com/render-oss/cli/archive/refs/tags/v2.24.0.tar.gz"
  sha256 "a3b6a5615d8a84d409ede5aa75305df0a43b3ed902129da5d0a32fa0417ab5b3"
  license "Apache-2.0"
  head "https://github.com/render-oss/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d6d42154bc309f88e7e56593c8bdf1b72ebcfae1943ecb75f9f52de453da919a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6d42154bc309f88e7e56593c8bdf1b72ebcfae1943ecb75f9f52de453da919a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6d42154bc309f88e7e56593c8bdf1b72ebcfae1943ecb75f9f52de453da919a"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8f68a55b9974ffcbba6734b375edef0f8f54345b6de0a1341c79a718537aa77"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "484c9b337d5383d9190109b678110718e7ba46e1fad6f62ba5603d310bd020a3"
    sha256 cellar: :any,                 x86_64_linux:  "784021dd3ab9388c6c19ac891e0e644751251ac7dd6f2c381c2523bedb8ff9a0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-X github.com/render-oss/cli/pkg/cfg.Version=#{version}]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/render --version")

    output = shell_output("#{bin}/render services -o json 2>&1", 1)
    assert_match "Error: no workspace set. Use `render workspace set` to set a workspace", output
  end
end
