class Zk < Formula
  desc "Plain text note-taking assistant"
  homepage "https://github.com/mickael-menu/zk"
  url "https://github.com/mickael-menu/zk/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "c38e88cbf8a6b1a00df51e1d87d6dbff4d13279c18bfef6ed275e7dc28dce0d8"
  license "GPL-3.0-only"
  revision 1
  head "https://github.com/mickael-menu/zk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7583df1a2bc12b3c70dcfdd02484a057d659a7aed167241af27457d3f9a6f2c6"
    sha256 cellar: :any,                 arm64_big_sur:  "cdc7eb09c7a77ba562d146b72e215f4bb4f0386bc91c56881e5b6c3cefa7d757"
    sha256 cellar: :any,                 monterey:       "410df6600a4bbbbcef8e61a9c15c0f620988325826a296250fea5c4ba6cf16f3"
    sha256 cellar: :any,                 big_sur:        "21f5fca1009f3e9239f0109992332b7ba534d00a08dc83913a891f1c4597e2ac"
    sha256 cellar: :any,                 catalina:       "c6107720d53ce13225f3909ce9c2a47d79539f542e86fa6895f04300fe1214e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30d712376cba92622014448e341294205410000341838ce5618092f5d5b6cb9f"
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
