class Src < Formula
  desc "Simple revision control: RCS reloaded with a modern UI"
  homepage "http://www.catb.org/~esr/src/"
  url "https://gitlab.com/esr/src/-/archive/1.42/src-1.42.tar.bz2"
  sha256 "493d23f4d7776bd84a537b7e8f59bcba0ba56c55513a69c117dbdcca2ea000aa"
  license "BSD-2-Clause"
  head "https://gitlab.com/esr/src.git", branch: "master"

  # The homepage links to the `stable` tarball but it can take longer than the
  # ten second livecheck timeout, so we check the Git tags as a workaround.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5cfeb410d284ec4be5daae8886da28dddd8a0f5c7cf52ec860f4111970f7ac2e"
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
