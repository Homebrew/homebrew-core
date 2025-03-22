class Xmq < Formula
  desc "Tool and language to work with xml/html/json"
  homepage "https://libxmq.org"
  url "https://github.com/libxmq/xmq/archive/refs/tags/3.3.2.tar.gz"
  sha256 "076211d8595360eda4b29cb8423927fb4a7296a7bb39b14de087befa3a39e86a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f362ef2d0b2e3a7eedada9fcab2d8416f1b8a2823120a2331a87157613044a60"
    sha256 cellar: :any,                 arm64_sonoma:  "f0ccd4bed78aefb1dd7b361cf2d6acd4c7d77044c080a8f8fc92fee429debf0a"
    sha256 cellar: :any,                 arm64_ventura: "278d2e835e0648f5a570c096b8ecc7c0d920fa2b079a4f1db46ca8d4bc1b677f"
    sha256 cellar: :any,                 sonoma:        "782915960236fdc44b975d8b5af0377f7cde3e86548d58b9fe9358b313c59f71"
    sha256 cellar: :any,                 ventura:       "84876ed3a249469215d2031185c6a7581ee128b55499a7f5adf616dc8927c932"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "369e5c8e7f199d79d8669de762277ccca9a120c1494707ed0494c64d81a1b4b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8bbcedfde6940f09e482faeb078545c9f2b6c9cb1e2611632affb1cc23187b5c"
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
