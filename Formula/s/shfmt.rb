class Shfmt < Formula
  desc "Autoformat shell script source code"
  homepage "https://github.com/mvdan/sh"
  url "https://github.com/mvdan/sh/archive/refs/tags/v3.13.1.tar.gz"
  sha256 "b31aad2d4c26b0c6e8ebe894d59022520bbebce33e082d7d29e4325eee35d308"
  license "BSD-3-Clause"
  head "https://github.com/mvdan/sh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bf8528e33b4d5c4d8572fa23f45a2dbe3935b54a21b522cc0e4059e5a70b4fcb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf8528e33b4d5c4d8572fa23f45a2dbe3935b54a21b522cc0e4059e5a70b4fcb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf8528e33b4d5c4d8572fa23f45a2dbe3935b54a21b522cc0e4059e5a70b4fcb"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7d542832f29366a897f46c3659e06e190ebf27458d1e8260b410d185cd6e6dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e3ee9253b76dc169b3be3a9d24dd15caebdcc1c82eebe1c2de549fdd87f4067"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e78519471a3c6a1f082c944277d3e97ee4cab817f7a8d92ee69c635a85cf3d3f"
  end

  depends_on "go" => :build
  depends_on "scdoc" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-s -w -extldflags=-static"
    inreplace "cmd/shfmt/main.go", "version = mod.Version", "version = \"#{version}\""
    system "go", "build", *std_go_args(ldflags:), "./cmd/shfmt"
    man1.mkpath
    system "scdoc < ./cmd/shfmt/shfmt.1.scd > #{man1}/shfmt.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shfmt --version")

    (testpath/"test").write "\t\techo foo"
    system bin/"shfmt", testpath/"test"
  end
end
