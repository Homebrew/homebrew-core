class Src < Formula
  desc "Simple revision control: RCS reloaded with a modern UI"
  homepage "http://www.catb.org/~esr/src/"
  url "https://gitlab.com/esr/src/-/archive/1.44/src-1.44.tar.bz2"
  sha256 "7885e8b30c9c8e35649a4e20c871fd25e15c30d031a977131f71a9196b03a9e9"
  license "BSD-2-Clause"
  head "https://gitlab.com/esr/src.git", branch: "master"

  # The homepage links to the `stable` tarball but it can take longer than the
  # ten second livecheck timeout, so we check the Git tags as a workaround.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9cac4a82561a5981c4174c70c5d7fc1ba066b44641b01f1c21fc8ced039d98a0"
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
