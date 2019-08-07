class Yaws < Formula
  desc "Webserver for dynamic content (written in Erlang)"
  homepage "http://yaws.hyber.org"
  url "https://github.com/klacke/yaws/archive/yaws-2.0.7.tar.gz"
  sha256 "083b1b6be581fdfb66d77a151bbb2fc3897b1b0497352ff6c93c2256ef2b08f6"
  head "https://github.com/klacke/yaws.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "68a2f3e85c7cac4a6377c5eb58bd0a3ae5dc6fb7a72a682e507dbcddf5fa4c48" => :mojave
    sha256 "6dddeec2cbce08b47d7b14e31d04b6e2e803965c47f44258dfd136b23f2e531c" => :high_sierra
    sha256 "5eb3a9b15641e43e00b9ffb4626d32fa2931a57b1f492c2b2a641036005d6f1e" => :sierra
    sha256 "f04163aed1bfe0397bc639d9903f80de457ca4391789049fc13e4f8a6410c798" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "erlang@20"

  # the default config expects these folders to exist
  skip_clean "var/log/yaws"
  skip_clean "lib/yaws/examples/ebin"
  skip_clean "lib/yaws/examples/include"

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--prefix=#{prefix}",
                          # Ensure pam headers are found on Xcode-only installs
                          "--with-extrainclude=#{MacOS.sdk_path}/usr/include/security"
    system "make", "install"

    cd "applications/yapp" do
      system "make"
      system "make", "install"
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
