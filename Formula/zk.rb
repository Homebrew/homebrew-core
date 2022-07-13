class Zk < Formula
  desc "Plain text note-taking assistant"
  homepage "https://github.com/mickael-menu/zk"
  url "https://github.com/mickael-menu/zk/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "c38e88cbf8a6b1a00df51e1d87d6dbff4d13279c18bfef6ed275e7dc28dce0d8"
  license "GPL-3.0-only"
  head "https://github.com/mickael-menu/zk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "077dc097d974f62c3cbbaa67d86cd7c1f4de7e2e09e4f388bb4bfcc58a3de497"
    sha256 cellar: :any,                 arm64_big_sur:  "46a31b019bfd5da2f2aa70438d4433d381814b0253d700cb462e2fa0ccb7779a"
    sha256 cellar: :any,                 monterey:       "f2e816ba27f9d71d654865833679f1495ee2db5ee055eebbea8aece512cee567"
    sha256 cellar: :any,                 big_sur:        "8ae18133111bc481ff6ee84675da7240d007a5787f5ccc6affc3e7c163b06e4b"
    sha256 cellar: :any,                 catalina:       "839538547be93690611f99d5395092374b290f1daa51aa1acfeb7b0179dee2b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab1a2d2d9a9912c0fff524d4eb63af15a28984877b2681fe2deb55bb445f79b7"
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
