class Termsvg < Formula
  desc "Record, share and export your terminal as a animated SVG image"
  homepage "https://github.com/MrMarble/termsvg"
  url "https://github.com/MrMarble/termsvg/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "a8352a3b2f12de97a5b2935885a1938633f46b02a4965efa6f1117de4b9cce83"
  license "GPL-3.0-only"
  head "https://github.com/MrMarble/termsvg.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ccbe6458f26a3a27b886ef5a1769c1eb5cb32c533015444b36a4b61fadc9e23"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ccbe6458f26a3a27b886ef5a1769c1eb5cb32c533015444b36a4b61fadc9e23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ccbe6458f26a3a27b886ef5a1769c1eb5cb32c533015444b36a4b61fadc9e23"
    sha256 cellar: :any_skip_relocation, sonoma:        "285ad5aba84d5b92adec6f8a405fb4241c2875e2a00d5806dba5c159354e408e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "867a2b6cdb1a33baf1d403a34e1e7e9945c23edda765f10052f37e17d6c03e7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8266922d6481d0ab3249ecb33138bed1c604883bed40834fe1ef289ea26ee7a"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux? && Hardware::CPU.arm?

    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/termsvg"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/termsvg --version")

    output = shell_output("#{bin}/termsvg play nonexist 2>&1", 80)
    assert_match "no such file or directory", output
  end
end
