class Xmq < Formula
  desc "Tool and language to work with xml/html/json"
  homepage "https://libxmq.org"
  url "https://github.com/libxmq/xmq/archive/refs/tags/3.3.1.tar.gz"
  sha256 "650f3f91c7e0b625412bf3dfbf4a8983cdf6d7b735e3745ab0a2a4c8246b0c0b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "112718e223c4c43ec682bbef6485e75c7e2cf10a5a0ee94f9786d1a637c3f689"
    sha256 cellar: :any,                 arm64_sonoma:  "535692f3a5adaba516cdaa784d82a2e61e4f291e8de3517a5cbcd1442b561e61"
    sha256 cellar: :any,                 arm64_ventura: "c7af315d458bb8eeabd94ef932869c41be5509048283f599121012644d9ed5d1"
    sha256 cellar: :any,                 sonoma:        "1c42e2b230f2257b17c8876adb6b124c714ed4929de0498e676ce57d1ffce177"
    sha256 cellar: :any,                 ventura:       "74ce8fda580296a6272f091cbace3f44daaaef7e6b5ce279c4edbbc6e943447e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18ae5c5bdd396ae19247252ff2b5538cf8c891325bbefea5c45502f04592774e"
  end

  head do
    url "https://github.com/libxmq/xmq.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "zlib"

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.xml").write <<~XML
      <root>
      <child>Hello Homebrew!</child>
      </root>
    XML
    output = shell_output("#{bin}/xmq test.xml select //child")
    assert_match "Hello Homebrew!", output
  end
end
