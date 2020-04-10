class Simh < Formula
  desc "Portable, multi-system simulator"
  homepage "http://simh.trailing-edge.com/"
  url "https://github.com/simh/simh/archive/v3.11-1.tar.gz"
  version "3.11.1"
  sha256 "c8a2fc62bfa9369f75935950512a4cac204fd813ce6a9a222b2c6a76503befdb"
  head "https://github.com/simh/simh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b78f11e370514c87d0db0e34c1775673abc9205e34661941f4a8d6b95ce00dfb" => :catalina
    sha256 "a5a7d3ca7f8a069f8cdd3b25fd1d976c32552c2104fc568894807954fb9a5dd4" => :mojave
    sha256 "47cb949cd8492242b06d6de3a0e61f618edf5313ed5adc3f85fe4e999c5757cc" => :high_sierra
    sha256 "eb9b2f1accc1e5d6804bf3ad340c40ab41d2365049c8a3aba1994d98321944d7" => :sierra
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
