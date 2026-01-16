class TheSilverSearcher < Formula
  desc "Code-search similar to ack"
  homepage "https://geoff.greer.fm/ag/"
  url "https://github.com/ggreer/the_silver_searcher/archive/refs/tags/2.2.0.tar.gz"
  sha256 "6a0a19ca5e73b2bef9481c29a508d2413ca1a0a9a5a6b1bd9bbd695a7626cbf9"
  license "Apache-2.0"
  head "https://github.com/ggreer/the_silver_searcher.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "276d212929fc29d0b5a72b42eb300f0e1ad727838c632856e28a0851f664475c"
    sha256 cellar: :any,                 arm64_sequoia: "34fbedc36a7a00917bcd1fdedf86ced45b7ecbefded0608c97b42fea6ae37a48"
    sha256 cellar: :any,                 arm64_sonoma:  "e78ff365b00788e134aefb9f3a2f25243cc36ca9c10e5e4314765488208fe74c"
    sha256 cellar: :any,                 sonoma:        "da85c70afdf95c8dd945294286a7290b162f311e5851c21d00e7b7a4584f64f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f7eda047a58dd6fef8eb616b62bc90fa2c0544aad705a411f01ca851b13da7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c98d0e73c3a358b4ff1056c17222f897f0c12a9470046199b833de55266e945"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build
  depends_on "pcre2"
  depends_on "xz"

  uses_from_macos "zlib"

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
