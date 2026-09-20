class Sequin < Formula
  desc "Human-readable ANSI sequences"
  homepage "https://github.com/charmbracelet/sequin"
  url "https://github.com/charmbracelet/sequin/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "52f4d704a6e019df05dfc0ee3808fdf6c7d3245dcaa6262db8ca33c9de303da9"
  license "MIT"
  head "https://github.com/charmbracelet/sequin.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b759d3c6c079ea1186e5d4132f4c7b7c755e42ea8173f12df1004a5dde4fc01a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b759d3c6c079ea1186e5d4132f4c7b7c755e42ea8173f12df1004a5dde4fc01a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b759d3c6c079ea1186e5d4132f4c7b7c755e42ea8173f12df1004a5dde4fc01a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2bb4e5a2e13d2a52aa71b0227c5d7b330b4a24f4ed2884c9d6ca90cf61bed92c"
    sha256 cellar: :any,                 x86_64_linux:      "f4ec0d0ec058f09811d80345517b7a7eee0ac7bf6696c6c3d761c51ca63afbda"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sequin -v")

    assert_match "CSI m: Reset style", pipe_output(bin/"sequin", "\x1b[m")
  end
end
