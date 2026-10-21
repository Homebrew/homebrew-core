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
    sha256 cellar: :any, arm64_golden_gate: "3bc5ab5a67dee41d60cd3357b1b0051246a183722d4772ad17fbb1cfd5bf0dcd"
    sha256 cellar: :any, arm64_tahoe:       "86dea1eeb6c635caad1c0ef7a8db5405c2214195149ca45d50db28d80ace37ff"
    sha256 cellar: :any, arm64_sequoia:     "a2797887ab6d8d0298fd184d896c0d7e8b63060cf9f7dca57f89cdeadb0bf449"
    sha256 cellar: :any, arm64_linux:       "d271c4cd35b8dc7f46638b833588d6996292a8ffe89d94dbf00921d94de5b621"
    sha256 cellar: :any, x86_64_linux:      "4ae991a44ee7a26e1141212d194b4a756b6e083e0194557db76e08e64274fa5d"
  end

  depends_on "go" => :build

  depends_on "icu4c@78"
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
