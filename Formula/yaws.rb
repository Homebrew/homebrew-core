class Yaws < Formula
  desc "Webserver for dynamic content (written in Erlang)"
  homepage "http://yaws.hyber.org"
  url "http://yaws.hyber.org/download/yaws-2.0.6.tar.gz"
  sha256 "69f96f8b9bb574b129b0f258fb8437fdfd8369d55aabc2b5a94f577dde49d00e"

  bottle do
    cellar :any_skip_relocation
    sha256 "fe9367164fe409d37868693a90eabd32cfde33e308c06707fcfcae64224f6514" => :high_sierra
    sha256 "960e0cc26cdfc876eb77e25e1d21fab64fc9d8fce5c4a28d557e31753e5610b9" => :sierra
    sha256 "4377a946fd346b777373e93ec06b50f660970bbc1664250c567f3971e2ebe13f" => :el_capitan
  end

  head do
    url "https://github.com/klacke/yaws.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "without-yapp", "Omit yaws applications"

  depends_on "erlang@20"

  # the default config expects these folders to exist
  skip_clean "var/log/yaws"
  skip_clean "lib/yaws/examples/ebin"
  skip_clean "lib/yaws/examples/include"

  def install
    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          # Ensure pam headers are found on Xcode-only installs
                          "--with-extrainclude=#{MacOS.sdk_path}/usr/include/security"
    system "make", "install"

    if build.with? "yapp"
      cd "applications/yapp" do
        system "make"
        system "make", "install"
      end
    end

    # the default config expects these folders to exist
    (lib/"yaws/examples/ebin").mkpath
    (lib/"yaws/examples/include").mkpath
  end

  def post_install
    (var/"log/yaws").mkpath
    (var/"yaws/www").mkpath
  end

  test do
    system bin/"yaws", "--version"
  end
end
