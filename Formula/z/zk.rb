class Zk < Formula
  desc "Plain text note-taking assistant"
  homepage "https://github.com/zk-org/zk"
  url "https://github.com/zk-org/zk/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "563331e1f5a03b4dd3a4ff642cc205cc7b6c3c350c98f627a3273067e7ec234c"
  license "GPL-3.0-only"
  revision 2
  head "https://github.com/zk-org/zk.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "10efe9c92516aeb1acd357235201f53a4c7e51ebb61a55f0a099ce8c2d5ed0e4"
    sha256 cellar: :any,                 arm64_sonoma:  "ea90c3b24d3500bf7beb2401e6dbc8d996f9b06d5d266b628e81d6f8d3a54fa7"
    sha256 cellar: :any,                 arm64_ventura: "a5dde8c954c2918010ba54cb7ab2d553eec6a43e6006c5e5a123c91777a91934"
    sha256 cellar: :any,                 sonoma:        "083dabc371d451af6681a0d95986eae25e10d82af8f5848222e47d73c5ce7bad"
    sha256 cellar: :any,                 ventura:       "50814ce90a03bcaf634590bdcb4f1894ef4ba2eb3a225a245f813e43764ba1b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a2dee63ae756188d8a38b9b147cc316eba321fdadd51caa680bb3146890f165"
  end

  depends_on "go" => :build

  depends_on "icu4c@76"
  uses_from_macos "sqlite"

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.Build=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "-tags", "fts5,icu"
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
