class Zk < Formula
  desc "Plain text note-taking assistant"
  homepage "https://github.com/mickael-menu/zk"
  url "https://github.com/mickael-menu/zk/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "ce4851be512c446658e0945574bea52531d25e481a4fdea632f31a488445db85"
  license "GPL-3.0-only"
  head "https://github.com/mickael-menu/zk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a6aa1921fab0eda0b175c505d63f6bf21c46c1a9b6f37eef8cd3b8c2ace3943f"
    sha256 cellar: :any,                 arm64_big_sur:  "3d918370887ef4ff0f0e8e1ce38356edc9b662d34eb0fc8e53c29ad9692a9a2d"
    sha256 cellar: :any,                 monterey:       "f210e169381a910c7ebae5cf0324264064c25b089aad537d1396879cc1c4e082"
    sha256 cellar: :any,                 big_sur:        "69800bc9ea862066f8be29ae4f381185a7bf4020fba7891e8af2e6188fcbbcbc"
    sha256 cellar: :any,                 catalina:       "d4ec1057af934cc49c68d499e08244fc29d12f1685bf55424a3044bab492b1b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12c44370985950a98c5d6b5bbe65281f09e718abddac5af7e5f4e0bd15e75b4e"
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
