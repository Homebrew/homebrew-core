class Quilt < Formula
  desc "Work with series of patches"
  homepage "https://savannah.nongnu.org/projects/quilt"
  url "https://download.savannah.gnu.org/releases/quilt/quilt-0.66.tar.gz"
  sha256 "314b319a6feb13bf9d0f9ffa7ce6683b06919e734a41275087ea457cc9dc6e07"
  license "GPL-2.0-or-later"
  revision 1
  head "https://git.savannah.gnu.org/git/quilt.git", branch: "master"

  livecheck do
    url "https://download.savannah.gnu.org/releases/quilt/"
    regex(/href=.*?quilt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6efc379230b920dd0815e6d659fc50a1c2561ded68a7bf2319fefa858630b057"
    sha256 cellar: :any_skip_relocation, big_sur:       "6efc379230b920dd0815e6d659fc50a1c2561ded68a7bf2319fefa858630b057"
    sha256 cellar: :any_skip_relocation, catalina:      "c4d1cf5f32d7e6d7f4ed49a5781ad549cd810ab22d06c1efdda6dc4ab9e3e0d5"
    sha256 cellar: :any_skip_relocation, mojave:        "c4d1cf5f32d7e6d7f4ed49a5781ad549cd810ab22d06c1efdda6dc4ab9e3e0d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcf04616c7a95a7f00ec6ffe0751770b751ab18c2bf42d241694416863bafbe3"
    sha256 cellar: :any_skip_relocation, all:           "11742a29f39b83e63339a576e6ac1a4c7015c195af4a137d061254d2adcfa0c0"
  end

  depends_on "coreutils"
  depends_on "gnu-sed"

  def install
    args = [
      "--prefix=#{prefix}",
      "--without-getopt",
    ]
    if OS.mac?
      args << "--with-sed=#{HOMEBREW_PREFIX}/bin/gsed"
      args << "--with-stat=/usr/bin/stat" # on macOS, quilt expects BSD stat
    else
      args << "--with-sed=#{HOMEBREW_PREFIX}/bin/sed"
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
