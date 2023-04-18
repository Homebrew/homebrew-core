class Zk < Formula
  desc "Plain text note-taking assistant"
  homepage "https://github.com/mickael-menu/zk"
  url "https://github.com/mickael-menu/zk/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "8f3d9957652583fae7045392091ee53be1afe3fcf9aed1a911d0cf5e0691a021"
  license "GPL-3.0-only"
  head "https://github.com/mickael-menu/zk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8ff6ac839af8f09ede3db7f9517cd4a4b255e0c8807b758dc7b4e8c9f62d91ff"
    sha256 cellar: :any,                 arm64_monterey: "44d7ce7d40393f8de0cea3cffb0bbd3f9c184e87e2e50cd9ee35d6f51f930d43"
    sha256 cellar: :any,                 arm64_big_sur:  "fd21bc8178875b1df99339ad31b60973181583d49fe81e86b6ba9826d1f5323a"
    sha256 cellar: :any,                 ventura:        "475eac02a56fa55fd1ed1941d45b6c4d9f5c90a998978b4a6b1b36597761bbd2"
    sha256 cellar: :any,                 monterey:       "d9a7b4c9c63437479f7ecef729d1807b563aa85cf70b13d14cc67e0d2554cf5b"
    sha256 cellar: :any,                 big_sur:        "04fa882b52d47700465fe21689ad2d1ecb2dc1836dd7b0de87d71ec5b8c800b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "936943183e29e3ee48211734566c0add16c1a48a2e8f593f4d3d7c1830d274bc"
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
