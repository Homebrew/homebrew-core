class Quilt < Formula
  desc "Work with series of patches"
  homepage "https://savannah.nongnu.org/projects/quilt"
  url "https://download.savannah.gnu.org/releases/quilt/quilt-0.69.tar.gz"
  sha256 "555ddffde22da3c86d1caf5a9c1fb8a152ac2b84730437bd39cc08849c9f4852"
  license "GPL-2.0-or-later"
  head "https://git.savannah.gnu.org/git/quilt.git", branch: "master"

  livecheck do
    url "https://download.savannah.gnu.org/releases/quilt/"
    regex(/href=.*?quilt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "93979fd118d49801525b0d28a8572a055893d3e3169ee9eff1bca64e69d9ccc2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93979fd118d49801525b0d28a8572a055893d3e3169ee9eff1bca64e69d9ccc2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93979fd118d49801525b0d28a8572a055893d3e3169ee9eff1bca64e69d9ccc2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "93979fd118d49801525b0d28a8572a055893d3e3169ee9eff1bca64e69d9ccc2"
    sha256 cellar: :any_skip_relocation, sonoma:        "93979fd118d49801525b0d28a8572a055893d3e3169ee9eff1bca64e69d9ccc2"
    sha256 cellar: :any_skip_relocation, ventura:       "93979fd118d49801525b0d28a8572a055893d3e3169ee9eff1bca64e69d9ccc2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0aadd65237093e1356cf63eef91a5ab80f8cba26bc8e034d05de7c3095dd64c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0aadd65237093e1356cf63eef91a5ab80f8cba26bc8e034d05de7c3095dd64c"
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
