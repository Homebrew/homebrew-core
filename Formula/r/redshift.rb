class Redshift < Formula
  desc "Adjust color temperature of your screen according to your surroundings"
  homepage "https://github.com/jonls/redshift"
  url "https://github.com/jonls/redshift/releases/download/v1.12/redshift-1.12.tar.xz"
  sha256 "d2f8c5300e3ce2a84fe6584d2f1483aa9eadc668ab1951b2c2b8a03ece3a22ba"
  license "GPL-3.0-or-later"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 arm64_tahoe:    "b3f728c06b42f585bdf50685e7613ee66f639d43f85030942edf712b6ad928ab"
    sha256 arm64_sequoia:  "82b1df8db7796fa1af92a7b3ef4ea428e4d94a65850a5e2cdb90f354605cf065"
    sha256 arm64_sonoma:   "b2ad69df7721d0d5c8777741384c3de6e24d370c394a4f39f6432239cdb2b158"
    sha256 arm64_ventura:  "a14f34f6fee41eb43734e14fc6b18965bc5438aa7a4acbf3a5b881e31bef5663"
    sha256 arm64_monterey: "639cdf26164ff6a637c3adb96d4e5b92f6712199c8d49276638965836ac142c9"
    sha256 arm64_big_sur:  "043dc8ec9eff54763ea0fdf2c3ca325a9906d8fd1098568255ced2a497841315"
    sha256 sonoma:         "ecccd726383b2a9fda6f1ce365744e74bd8d1e76b2031fd0f58caeb9daecee15"
    sha256 ventura:        "4bfe11cbe2b92cf2775376c681c96593bb2ff33a98766cd18d0a261bf8005179"
    sha256 monterey:       "442b3c30b0cd25d42a4c5e03ed166a264c59bb67b4eb51bbccef29c819e6aa39"
    sha256 big_sur:        "8be47c6b6015ca4ccd2c706dd58541c49c4177a1d69144452a7aa483c977f805"
    sha256 catalina:       "344ea69571839ab32210854f990474239fde828b10a019ec5e88695eb4c7ffcb"
    sha256 arm64_linux:    "c21e3b0726216ea136e4f022da78243fd5572e69f9a3fc7507c07831d95551d4"
    sha256 x86_64_linux:   "12372cb33e04989848070b332096420b45539cd69e31026545543207d7d0cc9a"
  end

  head do
    url "https://github.com/jonls/redshift.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "intltool" => :build
  depends_on "pkgconf" => :build
  depends_on "gettext"
  depends_on "glib"

  def install
    args = %w[
      --disable-silent-rules
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
    system "./configure", *args, *std_configure_args
    system "make", "install"
    pkgshare.install "redshift.conf.sample"
  end

  def caveats
    <<~EOS
      A sample .conf file has been installed to #{opt_pkgshare}.

      Please note redshift expects to read its configuration file from
      #{Dir.home}/.config/redshift/redshift.conf
    EOS
  end

  service do
    run opt_bin/"redshift"
    keep_alive true
    log_path File::NULL
    error_log_path File::NULL
  end

  test do
    system bin/"redshift", "-V"
  end
end
