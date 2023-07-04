class Txr < Formula
  desc "Lisp-like programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-289.tar.bz2"
  sha256 "d66dd05d8d6a955305a5e8406227c7903350e210253b8e7febe6dba5b300a373"
  license "BSD-2-Clause"

  livecheck do
    url "http://www.kylheku.com/cgit/txr"
    regex(/href=.*?txr[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c4ff666bfc67d2140ef81be4ff77d7ad6d64eadb424f61dd383d5a99186ab357"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5a31ebb107c9e8c6722c7c9df0a6d9675935f90d6975bb05c644c099f390e42"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "db8f6d1267ab7571f3991f8c85181be5e7bf4c7c1cade3a0ecd006843ff4039a"
    sha256 cellar: :any_skip_relocation, ventura:        "f72d16f0f9143212be3ae8b2d0b2eb0c92c20d9f7439e3f1126043303f90cc43"
    sha256 cellar: :any_skip_relocation, monterey:       "ef18b99b3f7b223a9825d44d93d9ef134537c07563f0c33e89eb093859ef8460"
    sha256 cellar: :any_skip_relocation, big_sur:        "29596a3243e5be3a9d796ab177e5c7b987fb59441e26ab559377827fdfb5d0c5"
  end

  depends_on "pkg-config" => :build
  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "libffi", since: :catalina

  def install
    system "./configure", "--prefix=#{prefix}", "--inline=static inline"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "3", shell_output("#{bin}/txr -p '(+ 1 2)'").chomp
  end
end
