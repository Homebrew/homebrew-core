class Zk < Formula
  desc "Plain text note-taking assistant"
  homepage "https://zk-org.github.io/zk/"
  url "https://github.com/zk-org/zk/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "a99c3a3ef376b9afb3d35cc955b588ce35b35e2ebe3492e65b21d9fe4e9ba4e9"
  license "GPL-3.0-only"
  head "https://github.com/zk-org/zk.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ef3376e7cd77f58a3c20478ace283c444db22dfdc43033571ca4c2d3729e4d21"
    sha256 cellar: :any,                 arm64_sonoma:  "78b63d840567a03590f82e3b7ff0ed05f078a140bef579be7e18fd4cbc28464e"
    sha256 cellar: :any,                 arm64_ventura: "3a03654ae49e4bdbbf1cc7f0a01e8d6c27fd2a1451a1fc1b3ffcb7d42834625d"
    sha256 cellar: :any,                 sonoma:        "f9b0141cbbbd6fa771a81d7021c5ac420662a54b64ab4748da29f88ba84deffd"
    sha256 cellar: :any,                 ventura:       "7cec72e73e0b125467cc0a1d1743820a2d75be1361e97b2f69af1f0d1f8fdea5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3df610fab94c6e1a05432b73438139a8609cc70731f4a7140c6555acce971d75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1985206d3802d58c635741d386f84509437aacf07a2c2fa9c2e933ca584d017b"
  end

  depends_on "go" => :build

  depends_on "icu4c@77"
  uses_from_macos "sqlite"

  def install
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
