class Utftex < Formula
  desc "Pretty print math in monospace fonts, using a TeX-like syntax"
  homepage "https://github.com/bartp5/libtexprintf"
  url "https://github.com/bartp5/libtexprintf/archive/refs/tags/v1.27.tar.gz"
  sha256 "1ee792e5a4b1691272367c837e58fe5c7c90d1253bde522eca28c48aa244963f"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b097def87ce2a42d882f12c78914297ae95d7f544f281d80bb699c415dfbf5c1"
    sha256 cellar: :any,                 arm64_sequoia: "1b632a10326e687284eec1088058933653ffe0fabe3696e42b1da39e63938680"
    sha256 cellar: :any,                 arm64_sonoma:  "f06c29f006abf9b07d9bd4832ca82d08dad6021b9470aedcd9dea3a96782261d"
    sha256 cellar: :any,                 sonoma:        "5f2b4dfb3f916dbdcbc3006a3f741a94e2f7947d61f4ba4af30dcee11b220516"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5c751c2580d67c56903ac82ba5673b42f6a3fab5ea021f25dc25138a37ac478"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99540b48b6874d68bfda00c3f13d13355965eba0627c5ba67d413890e7115874"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system bin/"utftex", "\\left(\\frac{hello}{world}\\right)"
  end
end
