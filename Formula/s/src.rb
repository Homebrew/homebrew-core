class Src < Formula
  desc "Simple revision control: RCS reloaded with a modern UI"
  homepage "http://www.catb.org/~esr/src/"
  url "https://gitlab.com/esr/src/-/archive/1.43/src-1.43.tar.bz2"
  sha256 "f9e232c61585c47c81f996ba98dc93479ced1c51ea527b79c420b8384491db0a"
  license "BSD-2-Clause"
  head "https://gitlab.com/esr/src.git", branch: "master"

  # The homepage links to the `stable` tarball but it can take longer than the
  # ten second livecheck timeout, so we check the Git tags as a workaround.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "080ff71d5b76bd67e6d07b091544b684ea25bc8d67ac5e0610aff8f20b622caa"
  end

  depends_on "asciidoctor" => :build
  depends_on "rcs"

  uses_from_macos "python"

  def install
    system "make"
    bin.install "src"
    man1.install "src.1"
  end

  test do
    (testpath/"test.txt").write "foo"
    ENV["COLUMNS"] = "80"
    system bin/"src", "commit", "-m", "hello", "test.txt"
    output = shell_output("#{bin}/src status test.txt")
    assert_match(/^=\s*test.txt/, output)
  end
end
