class Scrub < Formula
  desc "Writes patterns on magnetic media to thwart data recovery"
  homepage "https://code.google.com/archive/p/diskscrub/"
  url "https://github.com/chaos/scrub/releases/download/2.6.1/scrub-2.6.1.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/s/scrub/scrub_2.6.1.orig.tar.gz"
  sha256 "43d98d3795bc2de7920efe81ef2c5de4e9ed1f903c35c939a7d65adc416d6cb8"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "01146146976c9be7bf2b74b018e7b98a158407f7318ffe604bee4603270e6f4f" => :catalina
    sha256 "9343d2cc328739d3315f319eeb6704cbd8e98e8105065ff194fcb51456114c4e" => :mojave
    sha256 "c9e96dce0a6f2d7c3b32d481aae3a3aa2c0f42cd3c53b10e2fd60c6479ebf128" => :high_sierra
    sha256 "703ee9b222437bf008ceaa25ab802ace51f207bcba8503f88037896aee2fde40" => :sierra
    sha256 "82343d8c3b64b876f8afb208059c3a916590b45fe7998ee412d91d3df161fc92" => :el_capitan
    sha256 "40363789d6def7a867c3268832449f4f2ae5b3394f84c9063af2417c024f0eca" => :yosemite
    sha256 "2439531406dc59f8358b9a3fe242fd867643dd30c67a810e18ffb12dc09d9954" => :mavericks
  end

  head do
    url "https://github.com/chaos/scrub.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    path = testpath/"foo.txt"
    path.write "foo"

    output = shell_output("#{bin}/scrub -r -p dod #{path}")
    assert_match "scrubbing #{path}", output
    refute_predicate path, :exist?
  end
end
