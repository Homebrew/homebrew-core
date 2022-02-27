class Zk < Formula
  desc "Plain text note-taking assistant"
  homepage "https://github.com/mickael-menu/zk"
  url "https://github.com/mickael-menu/zk/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "102754f2722e7e4ff0a83715085c8bfdac090b440f89020123481a95b566730f"
  license "GPL-3.0-only"
  revision 1

  head "https://github.com/mickael-menu/zk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ce112a10870e5cdd752cbe76281d209cfec19247719771b52391028ad1b7139c"
    sha256 cellar: :any,                 arm64_big_sur:  "d36bd7d94f0008c736de5cfe2e4223d0c7c20787e14cf649889a9a6ebe6683f9"
    sha256 cellar: :any,                 monterey:       "1b25ef03a856fd00f78fb9abab558388f7382ab4060d518ffe8304be02b46c64"
    sha256 cellar: :any,                 big_sur:        "8e775095be3f5055eae9e8187c954a887068a0c8de021e43e1514cce13fa2768"
    sha256 cellar: :any,                 catalina:       "9d28c3e240b0ceed53da7701f39c8927642d17e8f90bc9c2388cfbbb02685551"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5aca583595a78d57225fab2d6dc7f9fc0c84223e725c6c3f6b287fd283f917c6"
  end

  depends_on "go" => :build

  depends_on "icu4c"
  uses_from_macos "sqlite"

  def install
    system "go", "build", *std_go_args(ldflags: "-X=main.Version=#{version} -X=main.Build=#{tap.user}"), "-tags", "fts5,icu"
  end

  test do
    system "#{bin}/zk", "init", "--no-input"
    system "#{bin}/zk", "index", "--no-input"
    (testpath/"testnote.md").write "note content"
    (testpath/"anothernote.md").write "todolist"

    output = pipe_output("#{bin}/zk list --quiet").chomp
    assert_match "note content", output
    assert_match "todolist", output
  end
end
