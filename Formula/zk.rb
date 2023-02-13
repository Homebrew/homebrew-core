class Zk < Formula
  desc "Plain text note-taking assistant"
  homepage "https://github.com/mickael-menu/zk"
  url "https://github.com/mickael-menu/zk/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "8f3d9957652583fae7045392091ee53be1afe3fcf9aed1a911d0cf5e0691a021"
  license "GPL-3.0-only"
  head "https://github.com/mickael-menu/zk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8f9a546a6e21364b1650537d99981a02c345a24bb4201cf123294288fa6ece8b"
    sha256 cellar: :any,                 arm64_monterey: "f2123a05eb3ed671f9038bd72c37b29c51c7db80f12fe31c581d7bb03dd23dd4"
    sha256 cellar: :any,                 arm64_big_sur:  "73836a0009042a242bf0edb57257c7a6486948af2b3873165bd7c6f2eed81503"
    sha256 cellar: :any,                 ventura:        "c64a7e6efa6db0ca5469ab84c2aa605f6aee6daffb513a6ddc7c1f4b091b0d5a"
    sha256 cellar: :any,                 monterey:       "c2c2b388e2096e83776f4e19b57c15f63758587463c3c21082ff3dafe2bbb5cc"
    sha256 cellar: :any,                 big_sur:        "e6a0b457b9f0d42800bfb5bec532b1c3bc4927e846b567158d92c48b9b78e32f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "360c1ca9bda927f22446cd9b866b4b77b05d5bb75ac72af64616ac3c2f17d1ee"
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
