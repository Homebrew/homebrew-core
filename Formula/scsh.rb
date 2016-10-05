class Scsh < Formula
  desc "Scheme shell"
  homepage "https://scsh.net/"
  url "https://ftp.scsh.net/pub/scsh/0.6/scsh-0.6.7.tar.gz"
  sha256 "c4a9f7df2a0bb7a7aa3dafc918aa9e9a566d4ad33a55f0192889de172d1ddb7f"

  bottle do
    rebuild 1
    sha256 "2f80d7fa957edf1230540c2730b62313d690c59ebd879b7b7a2645231b290bfc" => :sierra
    sha256 "637b6d2b0055ffe923f913e43efd1859124facc4e73c5315310dc3813105ea3f" => :el_capitan
    sha256 "093f70ab95855491d5a9ab8766ab11f9bee52588ccc07a30cb2e6a4fa9e81d02" => :yosemite
    sha256 "8724dac1e3adb8b2cfd881042a550477054bd7c588fc7d531bad74ff62186b34" => :mavericks
  end

  head do
    url "https://github.com/scheme/scsh.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "scheme48"
  end

  def install
    if build.head?
      system "autoreconf"
    else
      # will not build 64-bit
      ENV.m32
    end

    # build system is not parallel-safe
    ENV.deparallelize
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--infodir=#{info}",
                          "--mandir=#{man}"
    system "make", "install"
    rm_rf include
  end

  test do
    (testpath/"hello.scm").write <<-EOS.undent
      (display "Hello, World!") (newline)
    EOS

    assert_equal "Hello, World!\n", shell_output("#{bin}/scsh -s hello.scm")
  end
end
