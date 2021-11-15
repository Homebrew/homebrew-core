class Squirrel < Formula
  desc "High level, imperative, object-oriented programming language"
  homepage "http://www.squirrel-lang.org"
  url "https://downloads.sourceforge.net/project/squirrel/squirrel3/squirrel%203.1%20stable/squirrel_3_1_stable.tar.gz"
  version "3.1.0"
  sha256 "4845a7fb82e4740bde01b0854112e3bb92a0816ad959c5758236e73f4409d0cb"
  license "MIT"

  livecheck do
    url :stable
    regex(%r{url=.*?/squirrel[._-]v?(\d+(?:[_-]\d+)+)[._-]stable\.t}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48b8326518132bb8541c1472492ee2554c33755a9828bc90f6ff5ae14aa50079"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3eb8546645662f5803fdc10228ea5d8b0fdcb01023ba1e1dfc7213f15b986e2c"
    sha256 cellar: :any_skip_relocation, monterey:       "db623e033f46e8fd269977b12bcefaa7a32d1af206fea7073817325f76cb5de7"
    sha256 cellar: :any_skip_relocation, big_sur:        "d234067f8f8ae8d02c69c903bd71cfb714d7b732b37bae6e527ceb9ccc1b9dc4"
    sha256 cellar: :any_skip_relocation, catalina:       "036b6172b0a11dde45cc6e28613a0db3a2aa1a7a44f220d1bd963a1903533a56"
    sha256 cellar: :any_skip_relocation, mojave:         "3080041c6bda4ffb009faea5924917586204cb004f9a01ac434ff86e0cdb1cd1"
    sha256 cellar: :any_skip_relocation, high_sierra:    "c57b21bbdcac5cbaf3d7319d64f08c150d16592138bdf1027e7032f579e10091"
    sha256 cellar: :any_skip_relocation, sierra:         "f4d3e6db56838a29cd7247f0933de64bb35a6dac581a9ade879205cbfc9d93f7"
    sha256 cellar: :any_skip_relocation, el_capitan:     "0b6dab6fc2a9a9a9d68d8310977041bd20a492cfe91a6daef07638b0cea55aad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef0fb28b06ae9677d7f573189e5e2c8b012f1eb52d42b8d23d385117a826c2e5"
  end

  # Upstream patch to fix compilation with Xcode 9
  # https://github.com/albertodemichelis/squirrel/commit/a3a78eec
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/dcaba40/squirrel/xcode9.patch"
    sha256 "7821b25b11c477341553c29dce5fb3fca2541e829276be2b2e3cd0c5b5a225d2"
  end

  def install
    system "make"
    prefix.install %w[bin include lib]
    doc.install Dir["doc/*.pdf"]
    doc.install %w[etc samples]
    # See: https://github.com/Homebrew/homebrew/pull/9977
    (lib+"pkgconfig/libsquirrel.pc").write pc_file
  end

  def pc_file
    <<~EOS
      prefix=#{opt_prefix}
      exec_prefix=${prefix}
      libdir=/${exec_prefix}/lib
      includedir=/${prefix}/include
      bindir=/${prefix}/bin
      ldflags=  -L/${prefix}/lib

      Name: libsquirrel
      Description: squirrel library
      Version: #{version}

      Requires:
      Libs: -L${libdir} -lsquirrel -lsqstdlib
      Cflags: -I${includedir}
    EOS
  end

  test do
    (testpath/"hello.nut").write <<~EOS
      print("hello");
    EOS
    assert_equal "hello", shell_output("#{bin}/sq #{testpath}/hello.nut").chomp
  end
end
