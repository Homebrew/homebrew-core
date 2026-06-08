class TheSilverSearcher < Formula
  desc "Code-search similar to ack"
  homepage "https://geoff.greer.fm/ag/"
  url "https://github.com/ggreer/the_silver_searcher/archive/refs/tags/2.2.0.tar.gz"
  sha256 "6a0a19ca5e73b2bef9481c29a508d2413ca1a0a9a5a6b1bd9bbd695a7626cbf9"
  license "Apache-2.0"
  head "https://github.com/ggreer/the_silver_searcher.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "9e15a76d577686e2f6157918b498668861690527fb40186768b91ed2a6e423e5"
    sha256 cellar: :any,                 arm64_sequoia: "ce0f3d875b0d467b70050499f70e718e299bea7757798828bfa724c33de78cf3"
    sha256 cellar: :any,                 arm64_sonoma:  "14860b37f0568a9b254a20823c6a72bfcde847440a6c0d5243459aaa5afab980"
    sha256 cellar: :any,                 sonoma:        "1dd806566cbca47602b78add31578b9a9aa79b175d9a210a5d260e210e44529d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6bd4a0bc3759bf49f2fc549dc9143c8488632199d7c193cfe0e5bf4d67f62fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6905dec85c2cbb898f1d77a46524da036ac3935e5c192d2331dae88403604b9e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build
  depends_on "pcre2"
  depends_on "xz"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Apply Debian patch to port from pcre to pcre2.
  patch do
    url "https://sources.debian.org/data/main/s/silversearcher-ag/2.2.0%2Bgit20200805-1.2/debian/patches/enable_pcre2_support.patch"
    sha256 "86b4758595d96e6d049dca70b160ae4f60ea1198daa713a058628a749ab1be75"
  end

  def install
    ENV.append_to_cflags "-fcommon" if ENV.compiler.to_s.start_with?("gcc")
    # Stable tarball does not include pre-generated configure script
    system "./autogen.sh"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install", "bashcompdir=#{bash_completion}"
  end

  test do
    (testpath/"Hello.txt").write("Hello World!")
    system bin/"ag", "Hello World!", testpath
  end
end
