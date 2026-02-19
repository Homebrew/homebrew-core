class Xmq < Formula
  desc "Tool and language to work with xml/html/json"
  homepage "https://libxmq.org"
  url "https://github.com/libxmq/xmq/archive/refs/tags/4.0.1.tar.gz"
  sha256 "846cdd078209ee15189420c1ec47e6ffcf97fc5b196cd78b9952dc5de6c3e50e"
  license "MIT"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "57f9b83e2aa79916d184a0f9c84e0469780d18cb865fdc2ba709fcef285f9ad6"
    sha256 cellar: :any,                 arm64_sequoia: "1640a5ee0f308c681b68f7ed86a800d078646369db77dfddde067f83d6c40057"
    sha256 cellar: :any,                 arm64_sonoma:  "fd1245acbaa0450424fb34ce8d10a7e6a27d74ab846439b474355aefb36dd64b"
    sha256 cellar: :any,                 sonoma:        "d9bf5cfe88c080b54e304e799120032c0bfb3d82d5b00ddf572ac92bd47ad668"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f08017742793183450ae57864a7a3f9300be2694207f1055a9a3dcd25e347436"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29c501e5543ca76505576efb2b02b4fbaae32b5005ac9626abb975b1bdb318fb"
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

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
