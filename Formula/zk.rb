class Zk < Formula
  desc "Plain text note-taking assistant"
  homepage "https://github.com/mickael-menu/zk"
  url "https://github.com/mickael-menu/zk/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "c38e88cbf8a6b1a00df51e1d87d6dbff4d13279c18bfef6ed275e7dc28dce0d8"
  license "GPL-3.0-only"
  revision 1
  head "https://github.com/mickael-menu/zk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "14837986dabab8aaaf4b7ea3997c30c177f92d8c7bd152a688bc7624f836da58"
    sha256 cellar: :any,                 arm64_big_sur:  "e097162b85a06edf96a6b5e25a941ca259d640fedbf00d9b1ec8a6318d57e46a"
    sha256 cellar: :any,                 monterey:       "15aa4ad201f17ed789054dbbaf2836d397ba9747abed208963e53335b599b00c"
    sha256 cellar: :any,                 big_sur:        "2b60d285a933a1b095f2d89815c6a9c17bf386f5d4f2a3908f7009f04da860fc"
    sha256 cellar: :any,                 catalina:       "ce58623d1d9cacc6a91404290a329edbffc9f2b06f28321afa80b29ac602a4de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb28c15fd8efd70080d3a94a54fdf4a8a5e1c5f347d5b33451cbbf63677296a1"
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
