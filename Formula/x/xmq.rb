class Xmq < Formula
  desc "Tool and language to work with xml/html/json"
  homepage "https://libxmq.org"
  url "https://github.com/libxmq/xmq/archive/refs/tags/4.1.0.tar.gz"
  sha256 "a8637d1e95d0015e14b9f51a76798324ebd00a0135d44f686b9f5a446cd14af0"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "83aacb3ab6931c777f82fce09adcde72ad04446970fa0eac93f488b074a2a326"
    sha256 cellar: :any,                 arm64_sequoia: "2bcb7c3d49912a598504b1215f3a7d0a998649ab747de64161d5f64081df00f4"
    sha256 cellar: :any,                 arm64_sonoma:  "18aa2ebc522fcf2078cbc228bfae9dac262e9e97f7e871e29cd73863c9c988d6"
    sha256 cellar: :any,                 sonoma:        "631bffb5aee8fbd0c2de142080aae3724a033c30ae0af03b1bd3e20eeebf6e37"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "386b859219e1af64955da7f123b1680fee7a4e2567c53093141e18a378400e47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb5936a16ccc4b624a786c1336e66598b9bba1bf5cacac8927d9cb8844eeafbe"
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
