class Simh < Formula
  desc "Portable, multi-system simulator"
  homepage "http://simh.trailing-edge.com/"
  url "https://github.com/simh/simh/archive/v3.10.tar.gz"
  sha256 "21718eb59ffa7784a658ce62388b7dc83da888dfbb4888f6795eaa17cb62d7c9"
  head "https://github.com/simh/simh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8f4311a11b45c96213c82f0f08fad24442b7b901145836b6eec8bce6a02e9fe2" => :mojave
    sha256 "48f8dbc43fbcec170807bc4a0730ace70fd6e99c0619ecb26897e32d3bd3f03b" => :high_sierra
    sha256 "5b766137d34b8728a8a2ae3357c6c14063e2aabf3fa4e1107118764f05bc7cb0" => :sierra
    sha256 "38663141007d531b100b6408f27e1f8c3a43d3ec3cb5dc3b0086ac257077ea3f" => :el_capitan
    sha256 "0aa3e73267250ed3e466465f78d8bc4f286a7bb825c454dae5587af2023a313b" => :yosemite
    sha256 "e9043ec0dc68a5660a20fe270488dbfbf8741a77aae8dace61441fc348e74234" => :mavericks
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
    (pkgshare/"vax").install Dir["VAX/*.{bin,exe}"]
  end

  test do
    assert_match(/Goodbye/, pipe_output("#{bin}/altair", "exit\n", 0))
  end
end
