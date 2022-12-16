class Zk < Formula
  desc "Plain text note-taking assistant"
  homepage "https://github.com/mickael-menu/zk"
  url "https://github.com/mickael-menu/zk/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "c51d21a26a06c63c0dcdac262fd1a2a4e8d69f7f05dc0ec6aaa0365012d35781"
  license "GPL-3.0-only"
  revision 1
  head "https://github.com/mickael-menu/zk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "285d6d1e49f3d92e3deaeb4846a86899fce6a39e23e37340e716d5761a623466"
    sha256 cellar: :any,                 arm64_monterey: "5542c549e8733a6ef03b786f37c25ea5f99896bb6063024a3422505b47b1810d"
    sha256 cellar: :any,                 arm64_big_sur:  "9b5a6699f20db11c3fb7c868d31416510105991924449f1a818acf3d20337255"
    sha256 cellar: :any,                 ventura:        "315a3f9f8107d4e3003ebc8aabb9d9ba2cd552d3c98c856a7f6ddcd24a1ed19d"
    sha256 cellar: :any,                 monterey:       "17d1dd22249c505651e131eca81f81f9fd0119a8616daf1f893dddb6c20a30f1"
    sha256 cellar: :any,                 big_sur:        "bebe1d0ac7deee5ee472c8bc71c76230057d52d59e6c9ba9f21656fb80238bb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9bb6a07aec0019bb0c5d79d75af8dcb854f8d51b5d7c6682e539334e60c5128e"
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
