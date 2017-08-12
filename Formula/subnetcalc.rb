class Subnetcalc < Formula
  desc "IPv4/IPv6 subnet calculator"
  homepage "https://www.uni-due.de/~be0001/subnetcalc/"
  url "https://www.uni-due.de/~be0001/subnetcalc/download/subnetcalc-2.4.7.tar.gz"
  sha256 "5cf538837b633e5d48bed417ddae5f1ca87ee60c4d44550d8d0c87109a990071"

  bottle do
    cellar :any
    sha256 "343b5a8f3b93f3690ffd8fb9fc2a5d25834f848cde5116c06923f764590031a4" => :sierra
    sha256 "ec894fb019887560fa4b11c46f472d9788f7bbe7418666ee93c54d76bfc140bf" => :el_capitan
    sha256 "0d119ceba4bc98bac876ad593e8483c902f1f530d5f34e5aff9fe70fb420f522" => :yosemite
  end

  head do
    url "https://github.com/dreibh/subnetcalc.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  depends_on "geoip" => :recommended

  def install
    args = ["--disable-dependency-tracking",
            "--disable-silent-rules",
            "--prefix=#{prefix}"]
    args << "--with-geoip=no" if build.without? "geoip"

    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    system "make", "install"
  end

  test do
    system "#{bin}/subnetcalc", "::1"
  end
end
