class Redshift < Formula
  desc "Adjust color temperature of your screen according to your surroundings"
  homepage "http://jonls.dk/redshift/"
  url "https://github.com/jonls/redshift/releases/download/v1.12/redshift-1.12.tar.xz"
  sha256 "d2f8c5300e3ce2a84fe6584d2f1483aa9eadc668ab1951b2c2b8a03ece3a22ba"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    rebuild 1
    sha256 arm64_monterey: "639cdf26164ff6a637c3adb96d4e5b92f6712199c8d49276638965836ac142c9"
    sha256 arm64_big_sur:  "043dc8ec9eff54763ea0fdf2c3ca325a9906d8fd1098568255ced2a497841315"
    sha256 monterey:       "442b3c30b0cd25d42a4c5e03ed166a264c59bb67b4eb51bbccef29c819e6aa39"
    sha256 big_sur:        "8be47c6b6015ca4ccd2c706dd58541c49c4177a1d69144452a7aa483c977f805"
    sha256 catalina:       "344ea69571839ab32210854f990474239fde828b10a019ec5e88695eb4c7ffcb"
    sha256 mojave:         "71ec07212f543d7a4152f04627f2fe9cabcbc121caae584b24070f05101ae4dd"
    sha256 x86_64_linux:   "12372cb33e04989848070b332096420b45539cd69e31026545543207d7d0cc9a"
  end

  head do
    url "https://github.com/jonls/redshift.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-silent-rules
      --disable-dependency-tracking
      --disable-geoclue
      --disable-geoclue2
      --with-systemduserunitdir=no
      --disable-gui
    ]

    if OS.mac?
      args << "--enable-corelocation"
      args << "--enable-quartz"
    end

    system "./bootstrap" if build.head?
    system "./configure", *args
    system "make", "install"
    pkgshare.install "redshift.conf.sample"
  end

  def caveats
    <<~EOS
      A sample .conf file has been installed to #{opt_pkgshare}.

      Please note redshift expects to read its configuration file from
      #{ENV["HOME"]}/.config/redshift/redshift.conf
    EOS
  end

  service do
    run opt_bin/"redshift"
    keep_alive true
    log_path "/dev/null"
    error_log_path "/dev/null"
  end

  test do
    system "#{bin}/redshift", "-V"
  end
end
