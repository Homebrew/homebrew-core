class Sleuthkit < Formula
  desc "Forensic toolkit"
  homepage "https://www.sleuthkit.org/"
  url "https://github.com/sleuthkit/sleuthkit/releases/download/sleuthkit-4.11.1/sleuthkit-4.11.1.tar.gz"
  sha256 "8ad94f5a69b7cd1a401afd882ab6b8e5daadb39dd2a6a3bbd5aecee2a2ea57a0"
  license all_of: ["IPL-1.0", "CPL-1.0", "GPL-2.0-or-later"]

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/sleuthkit[._-]v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4d6edfce5609c0c8cd5bccfa2791ca42cd8cb10ccdd0cb59de91fdd2bbbdc3a3"
    sha256 cellar: :any,                 arm64_big_sur:  "85019f9077ffbfec1bd7278531d33a8a033cc7682cc10618e1d9898064f4db9a"
    sha256 cellar: :any,                 monterey:       "990b3f3baed61d5392ae167d855ab217524ed72e35bdcff550e313ebd39b049f"
    sha256 cellar: :any,                 big_sur:        "4aaa6a42f0f77b5e8bdcca4e7ddc2e66c72b1bf358ca906409bd4ff5393fce04"
    sha256 cellar: :any,                 catalina:       "36ab7ad51a701faf2e5e864c8b4a472ea627ff556d07214f0eeda3372559b77b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6ceaa7245ddf1eb80f694be614c14cae590d19b6418f92e57c914d2e780806f"
  end

  depends_on "ant" => :build
  depends_on "afflib"
  depends_on "libewf"
  depends_on "libpq"
  depends_on "openjdk"

  uses_from_macos "sqlite"

  conflicts_with "ffind", because: "both install a `ffind` executable"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix
    ENV["ANT_FOUND"] = Formula["ant"].opt_bin/"ant"
    ENV.append_to_cflags "-DNDEBUG"

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"

    cd "bindings/java" do
      system "ant"

      inreplace ["Makefile", "jni/Makefile"], Superenv.shims_path/"ld", "ld" if OS.linux?
    end
    prefix.install "bindings"
  end

  test do
    system "#{bin}/tsk_loaddb", "-V"
  end
end
