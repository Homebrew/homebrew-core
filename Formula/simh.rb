class Simh < Formula
  desc "Portable, multi-system simulator"
  homepage "http://simh.trailing-edge.com/"
  url "http://simh.trailing-edge.com/sources/simhv39-0.zip"
  sha256 "e49b259b66ad6311ca9066dee3d3693cd915106a6938a52ed685cdbada8eda3b"
  version "3.9-0"

  head "https://github.com/simh/simh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5b766137d34b8728a8a2ae3357c6c14063e2aabf3fa4e1107118764f05bc7cb0" => :sierra
    sha256 "38663141007d531b100b6408f27e1f8c3a43d3ec3cb5dc3b0086ac257077ea3f" => :el_capitan
    sha256 "0aa3e73267250ed3e466465f78d8bc4f286a7bb825c454dae5587af2023a313b" => :yosemite
    sha256 "e9043ec0dc68a5660a20fe270488dbfbf8741a77aae8dace61441fc348e74234" => :mavericks
  end

  # After 3.9-0 the project moves to https://github.com/simh/simh
  # It doesn't actually fail, but the makefile queries llvm-gcc -v --help a lot
  # to determine what flags to throw.  It is simply not designed for clang.
  # Remove at the next revision that will support clang (see github site).
  fails_with :clang do
    build 421
    cause "The program is closely tied to gcc & llvm-gcc in this revision."
  end

  def install
    ENV.deparallelize unless build.head?
    inreplace "makefile", "GCC = gcc", "GCC = #{ENV.cc}"
    inreplace "makefile", "CFLAGS_O = -O2", "CFLAGS_O = #{ENV.cflags}"
    system "make", "USE_NETWORK=1", "all"
    bin.install Dir["BIN/*"]
    Dir["**/*.txt"].each do |f|
      (doc/File.dirname(f)).install f
    end
    (share/"simh/vax").install Dir["VAX/*.{bin,exe}"]
  end

  test do
    assert_match(/Goodbye/, pipe_output("#{bin}/altair", "exit\n", 0))
  end
end
