class Redstore < Formula
  desc "Lightweight RDF triplestore powered by Redland"
  homepage "https://www.aelius.com/njh/redstore/"
  url "https://www.aelius.com/njh/redstore/redstore-0.5.4.tar.gz"
  sha256 "58bd65fda388ab401e6adc3672d7a9c511e439d94774fcc5a1ef6db79c748141"
  license "GPL-3.0"

  livecheck do
    url :homepage
    regex(/href=.*?redstore[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "55306289261abde9b677d1906bb58420dc0bd3a52b775c3257ccb80c5ba04cdb"
    sha256 cellar: :any,                 arm64_monterey: "6043b778fa8d393eb0505eca982e0f2dcba99354aa3c6bba9d1042de6425bac7"
    sha256 cellar: :any,                 arm64_big_sur:  "03952d80ba4b35e0a1a7a85a9ae9fe56e9e31bd6e2797729c28ffee377ee2fcf"
    sha256 cellar: :any,                 ventura:        "840637ec24ca832cad462cfbe3fa6f8693ccf86c5e74edeeccab5e12a3573633"
    sha256 cellar: :any,                 monterey:       "1ae97b18f1cb08f3872712accb48942d7c992a76f4dddae0b7a6566d22f40ec5"
    sha256 cellar: :any,                 big_sur:        "fa44b96b71ff73060973893222eb264f18c54f8c64ebb73c903eef2e544868ee"
    sha256 cellar: :any,                 catalina:       "f473645a1903ac48caf0bea886c13636ca093c4ca6f57f83ce9ffc4864f88ee5"
    sha256 cellar: :any,                 mojave:         "a17c99ed5d7162eb742eef7b8764c64082fff26895baa81cb26cb75ced03db5e"
    sha256 cellar: :any,                 high_sierra:    "fbd9814ed5e35fb1c964d6f581edebfc35e7d35cba0b89ea735247131c5559ac"
    sha256 cellar: :any,                 sierra:         "e507eab072e33f0cee1ca08efb51ab06d65cee3a64248ec6badbd4f601f5c674"
    sha256 cellar: :any,                 el_capitan:     "5ae64e4a536011ef3f68d2e8b4253624f60995025064de38f3a38308dd005421"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f459a58381dd6067d033bb20eb4101af9136f5260796bd2daee07cf6365c3bde"
  end

  depends_on "pkg-config" => :build
  depends_on "redland"

  def install
    ENV.append "CFLAGS", "-D_GNU_SOURCE" unless OS.mac?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
