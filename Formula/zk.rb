class Zk < Formula
  desc "Plain text note-taking assistant"
  homepage "https://github.com/mickael-menu/zk"
  url "https://github.com/mickael-menu/zk/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "57dd9e9bf1f93e9a5e3d2ed94ebb1477dda2f0cd62004964a3c8ea9767ce51fd"
  license "GPL-3.0-only"
  head "https://github.com/mickael-menu/zk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "21cc3b5384e0a7b99084639b2f924c1ff3c0909b3eb251b8747076e2b0547834"
    sha256 cellar: :any,                 arm64_big_sur:  "18505544f41597f235f691e386bdf37a30c18c347fabcdf621cd120e76751ef8"
    sha256 cellar: :any,                 monterey:       "3bf9f8757a1e9375cb6e281beae29afef8ce152dfb6aa2df1c4ce6dcba5b4bc0"
    sha256 cellar: :any,                 big_sur:        "0b4183d720134da5f7ce7319581b58a2f3eb8f86c2f2fc36f5e6c9476a52014e"
    sha256 cellar: :any,                 catalina:       "c739740ac4f72eecb9c711c91b61b0b3b6ca0d15b9fd1506424247b411e6cfcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07982a4d2542edd15e6d64bd49c36f5211de6ef23d7fde732733f815c02bba5f"
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
