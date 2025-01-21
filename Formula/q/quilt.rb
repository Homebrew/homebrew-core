class Quilt < Formula
  desc "Work with series of patches"
  homepage "https://savannah.nongnu.org/projects/quilt"
  url "https://download.savannah.gnu.org/releases/quilt/quilt-0.68.tar.gz"
  sha256 "fe8c09de03c106e85b3737c8f03ade147c956b79ed7af485a1c8a3858db38426"
  license "GPL-2.0-or-later"
  head "https://git.savannah.gnu.org/git/quilt.git", branch: "master"

  livecheck do
    url "https://download.savannah.gnu.org/releases/quilt/"
    regex(/href=.*?quilt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2b6755e89daa3a57fa60ad323cf75e0600cbd35b2149148546d023be74b24a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2b6755e89daa3a57fa60ad323cf75e0600cbd35b2149148546d023be74b24a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "beda4b671dafc8440a3d73d8512d6ebfdb079ec999080db08085f76858d5be3b"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2b6755e89daa3a57fa60ad323cf75e0600cbd35b2149148546d023be74b24a5"
    sha256 cellar: :any_skip_relocation, ventura:       "beda4b671dafc8440a3d73d8512d6ebfdb079ec999080db08085f76858d5be3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10a962d1f5d639afac31216ef075e670aedf9b302e3f2fd5d79c9c9e51865384"
  end

  depends_on "coreutils"
  depends_on "gnu-sed"

  on_ventura :or_newer do
    depends_on "diffutils"
    depends_on "gpatch"
  end

  def install
    args = [
      "--prefix=#{prefix}",
      "--without-getopt",
    ]
    if OS.mac?
      args << "--with-sed=#{Formula["gnu-sed"].opt_bin}/gsed"
      args << "--with-stat=/usr/bin/stat" # on macOS, quilt expects BSD stat
      if MacOS.version >= :ventura
        args << "--with-diff=#{Formula["diffutils"].opt_bin}/diff"
        args << "--with-patch=#{Formula["gpatch"].opt_bin}/gpatch"
      end
    else
      args << "--with-sed=#{Formula["gnu-sed"].opt_bin}/sed"
    end
    system "./configure", *args

    system "make"
    system "make", "install", "emacsdir=#{elisp}"
  end

  test do
    (testpath/"patches").mkpath
    (testpath/"test.txt").write "Hello, World!"
    system bin/"quilt", "new", "test.patch"
    system bin/"quilt", "add", "test.txt"
    rm "test.txt"
    (testpath/"test.txt").write "Hi!"
    system bin/"quilt", "refresh"
    assert_match(/-Hello, World!/, File.read("patches/test.patch"))
    assert_match(/\+Hi!/, File.read("patches/test.patch"))
  end
end
