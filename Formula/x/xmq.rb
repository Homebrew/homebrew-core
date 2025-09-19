class Xmq < Formula
  desc "Tool and language to work with xml/html/json"
  homepage "https://libxmq.org"
  url "https://github.com/libxmq/xmq/archive/refs/tags/4.0.1.tar.gz"
  sha256 "846cdd078209ee15189420c1ec47e6ffcf97fc5b196cd78b9952dc5de6c3e50e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7e8e71d92b11f5e3ec1b5b5a863c3d173c967286d301006af555b6b9ecfb6a23"
    sha256 cellar: :any,                 arm64_sequoia: "42095874ba74ca331ada2c067d2fbcd6e19efe70413c5f718bb4b09aef313e5d"
    sha256 cellar: :any,                 arm64_sonoma:  "d57deede2a93c04f0f14906dd26b227cf4a155f3cbbbfec8f8907058bf0c5fc3"
    sha256 cellar: :any,                 arm64_ventura: "8aca1bdd68bd3920d5849df45614c55c38af154ee1dd40e28cd4828ca614eb6a"
    sha256 cellar: :any,                 sonoma:        "bf5db137f33a6b09d401804efd10ce28710a2143d8adb482a56dc24b275e26ad"
    sha256 cellar: :any,                 ventura:       "12e55f6db9480dc671c5d23f603b88c9adac0051391b9fcbdc37116974f84918"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "165b86a489c050cdfedb74e27c16ef77d3bfb90c0f1d8e73cde376b6552531e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abaff1f72a7abb52ae8a84f576fae750c4322345327209ad996c363709fc3363"
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
