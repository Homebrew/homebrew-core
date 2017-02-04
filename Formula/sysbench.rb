class Sysbench < Formula
  desc "System performance benchmark tool"
  homepage "https://github.com/akopytov/sysbench"
  url "https://github.com/akopytov/sysbench/archive/1.0.0.tar.gz"
  sha256 "c73817799ed646dced6f13899cd01145c775cdcf6d431d1689c3c084ed45eb29"

  bottle do
    cellar :any
    sha256 "0046dc8a940ebad605027a67fc2371ebf04fee1106300d9d90d37bd1088e55a4" => :sierra
    sha256 "123270f2b97760e43a575585d1a1b9e815776edaaaa2a33faf419f5d60c18894" => :el_capitan
    sha256 "c55629bcc6aa72d622d7998059136d49993dffd7394467fbf60711252d3f2655" => :yosemite
    sha256 "1128a41e37dc93806e3fe81920cac22c046467e5f2a2d7e4bf2e20c4c8974224" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on :postgresql => :optional
  depends_on :mysql => :recommended

  def install
    # Fixes "dyld: lazy symbol binding failed: Symbol not found: _clock_gettime"
    # Reported 4 Feb 2017 https://github.com/akopytov/sysbench/issues/105
    if MacOS.version == :el_capitan && MacOS::Xcode.installed? && MacOS::Xcode.version >= "8.0"
      ENV["ac_cv_have_decl_clock_gettime"] = "no"
    end

    system "./autogen.sh"

    args = ["--prefix=#{prefix}"]
    if build.with? "mysql"
      args << "--with-mysql"
    else
      args << "--without-mysql"
    end
    args << "--with-psql" if build.with? "postgresql"

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/sysbench", "--test=cpu", "--cpu-max-prime=1", "run"
  end
end
