class Scrub < Formula
  desc "Writes patterns on magnetic media to thwart data recovery"
  homepage "https://code.google.com/archive/p/diskscrub/"
  url "https://github.com/chaos/scrub/releases/download/2.6.1/scrub-2.6.1.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/s/scrub/scrub_2.6.1.orig.tar.gz"
  sha256 "43d98d3795bc2de7920efe81ef2c5de4e9ed1f903c35c939a7d65adc416d6cb8"
  license "GPL-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5884d933276054cc834373533861549b84313fac6acc9d9557897791d2ec85e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5ae1b98ef6a66707490f04eb3d5a14c7536b9509c90213fb3bb397a993ca79cc"
    sha256 cellar: :any_skip_relocation, monterey:       "5a3fb4dfca2c4eb938f5c6a5d51071af0b0cc1dee2043a4af5eb970a6ae14c71"
    sha256 cellar: :any_skip_relocation, big_sur:        "ebb6d9f6cab14e6a4d7cab7336aa033c7e02b8ec50b4c0af6f8734ce92766e58"
    sha256 cellar: :any_skip_relocation, catalina:       "01146146976c9be7bf2b74b018e7b98a158407f7318ffe604bee4603270e6f4f"
    sha256 cellar: :any_skip_relocation, mojave:         "9343d2cc328739d3315f319eeb6704cbd8e98e8105065ff194fcb51456114c4e"
    sha256 cellar: :any_skip_relocation, high_sierra:    "c9e96dce0a6f2d7c3b32d481aae3a3aa2c0f42cd3c53b10e2fd60c6479ebf128"
    sha256 cellar: :any_skip_relocation, sierra:         "703ee9b222437bf008ceaa25ab802ace51f207bcba8503f88037896aee2fde40"
    sha256 cellar: :any_skip_relocation, el_capitan:     "82343d8c3b64b876f8afb208059c3a916590b45fe7998ee412d91d3df161fc92"
    sha256 cellar: :any_skip_relocation, yosemite:       "40363789d6def7a867c3268832449f4f2ae5b3394f84c9063af2417c024f0eca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a70d052c1010c990d18bf17558ef04b4c9949ce65e42c25fddc9f8fcff2f371"
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
