class Zk < Formula
  desc "Plain text note-taking assistant"
  homepage "https://zk-org.github.io/zk/"
  url "https://github.com/zk-org/zk/archive/refs/tags/v0.15.7.tar.gz"
  sha256 "69a9f72a0b18d89b2a7ec080aa3c2fbca0e5cfb31bfa89bf47e64c3f8a2d1ad0"
  license "GPL-3.0-only"
  head "https://github.com/zk-org/zk.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "17a307b11212fbbb7a5c189ba5ef1ae9bdc40b7482636dc14bd7ab59d7c19667"
    sha256 cellar: :any, arm64_tahoe:       "a9262d927cd99f23408ba2e2c099790b6c85e88b439cfcfaefa386ac91833ee0"
    sha256 cellar: :any, arm64_sequoia:     "1dc6aeee97969369c46a43c08003c0b700e0b892f049232114b6a96f6e19bf41"
    sha256 cellar: :any, arm64_linux:       "15b415f05cd374d72d696f8dbc427952714604a7295246906d8e7e00da3bac27"
    sha256 cellar: :any, x86_64_linux:      "6f294a27742322ff5c74023be48de9408dfd3517b09efa4d7b592f993f641f80"
  end

  depends_on "go" => :build

  depends_on "icu4c@79"
  uses_from_macos "sqlite"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = "-X main.Version=#{version} -X main.Build=#{tap.user}"
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
