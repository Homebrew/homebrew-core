class Zk < Formula
  desc "Plain text note-taking assistant"
  homepage "https://zk-org.github.io/zk/"
  url "https://github.com/zk-org/zk/archive/refs/tags/v0.15.5.tar.gz"
  sha256 "a3260eb1c6309a70a27d0e81c32fce58a9856905e781ea4138aa87d523e910aa"
  license "GPL-3.0-only"
  head "https://github.com/zk-org/zk.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "fd5a26e3163acc9ed2c44788594a3374c5f9049a1838f15ffe46a2b2cf369dc2"
    sha256 cellar: :any, arm64_sequoia: "a56e02e6a2be6804eabfc51c7b00a4e4be071dee1b7080f0ccc30cc7308c6d0e"
    sha256 cellar: :any, arm64_sonoma:  "b98538e297470a91e21a57148fe1c3aa0226dfc68ea7e2f16d6972312d806263"
    sha256 cellar: :any, sonoma:        "6c27636944aa3e758ffd1328eb4b6d1d6d6fa2467bdaa4e472450514811bead0"
    sha256 cellar: :any, arm64_linux:   "252c76eae815d1af8887493001cede24b3f8b0bcffeb559ab05ecf68e9408fa3"
    sha256 cellar: :any, x86_64_linux:  "2d5ab432f142f7343cb369e4786e72d1980e28fbb7f5c66ba4d6698543e435fb"
  end

  depends_on "go" => :build

  depends_on "icu4c@78"
  uses_from_macos "sqlite"

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = "-s -w -X main.Version=#{version} -X main.Build=#{tap.user}"
    tags = %w[fts5 icu]
    system "go", "build", *std_go_args(ldflags:, tags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zk --version")

    system bin/"zk", "init", "--no-input"
    system bin/"zk", "index", "--no-input"
    (testpath/"testnote.md").write "note content"
    (testpath/"anothernote.md").write "todolist"

    output = pipe_output("#{bin}/zk list --quiet").chomp
    assert_match "note content", output
    assert_match "todolist", output
  end
end
