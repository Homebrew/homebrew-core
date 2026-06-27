class Render < Formula
  desc "Command-line interface for Render"
  homepage "https://render.com/docs/cli"
  url "https://github.com/render-oss/cli/archive/refs/tags/v2.20.0.tar.gz"
  sha256 "ad45606b04d94499867067436e5bb93be1185b79d72725fd3da5b9aa0e686ba9"
  license "Apache-2.0"
  head "https://github.com/render-oss/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b50d72c02a7fbb94cac34728fb0a7a405235907775f3d54719909858305d4ccb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b50d72c02a7fbb94cac34728fb0a7a405235907775f3d54719909858305d4ccb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b50d72c02a7fbb94cac34728fb0a7a405235907775f3d54719909858305d4ccb"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c9e152dc705f54c363ec3ae42f483580b4cfd3290cd6192a4a55ca277332b39"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "230a1b91de3879a086605f9acc7aa953e7ae0302e11d8c50d59f4e16edda76a6"
    sha256 cellar: :any,                 x86_64_linux:  "79275792f9003992e623adff525d99db94d3a89532a9717018eac8fad87c4d34"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/render-oss/cli/pkg/cfg.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/render --version")

    output = shell_output("#{bin}/render services -o json 2>&1", 1)
    assert_match "Error: no workspace set. Use `render workspace set` to set a workspace", output
  end
end
