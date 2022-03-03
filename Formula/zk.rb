class Zk < Formula
  desc "Plain text note-taking assistant"
  homepage "https://github.com/mickael-menu/zk"
  url "https://github.com/mickael-menu/zk/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "102754f2722e7e4ff0a83715085c8bfdac090b440f89020123481a95b566730f"
  license "GPL-3.0-only"
  revision 1

  head "https://github.com/mickael-menu/zk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1ecd4c4a83f2676c61918eb3ff0f7b0013a8a2bceae5a3b678443356ea9fd03c"
    sha256 cellar: :any,                 arm64_big_sur:  "292db4b6028b6a480119311ac979d37d1241740d0e6314ffe7f6ef30a04237c4"
    sha256 cellar: :any,                 monterey:       "4a16bc95bac724ef0fa2acf8ee6c7ff260b407db5ceae41695ff7cc25eeeb121"
    sha256 cellar: :any,                 big_sur:        "b5888a0672f0a1ff905a0fc762384b93dbf02fbe543a4fc219ee5d01d5c90a33"
    sha256 cellar: :any,                 catalina:       "50c4fa5f0aa49980a566d7c96f157386b8d6b51f335c78b119d0c55193a8bf2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f5e2ce08ded8f8ce1e8903a3aa6d5a88e85b18ff75bd09b80feecba9664b65d"
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
