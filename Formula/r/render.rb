class Render < Formula
  desc "Command-line interface for Render"
  homepage "https://render.com/docs/cli"
  url "https://github.com/render-oss/cli/archive/refs/tags/v2.22.0.tar.gz"
  sha256 "aa0d4df1f3fc913823c185b8f07f6353a53292f79ea4ef369ed4d254f543e008"
  license "Apache-2.0"
  head "https://github.com/render-oss/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5095a5baab6f1d826298fe6f8d92c42156c866f7803d350f401317b94570dcb2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5095a5baab6f1d826298fe6f8d92c42156c866f7803d350f401317b94570dcb2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5095a5baab6f1d826298fe6f8d92c42156c866f7803d350f401317b94570dcb2"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd1aae307eb2156128463e20cea13c0a5f538aa6fd93dff1b8151a5f1b89745d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6548f24aa2c5854a402fd3a232e9824adbe8a4a015aed8168474b7b5aadecc1e"
    sha256 cellar: :any,                 x86_64_linux:  "8c559accb2dbed5a737e2f03f3c33e31ef82a22a9eb99ae2d0c3f51dbcfacfc6"
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
