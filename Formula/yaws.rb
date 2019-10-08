class Yaws < Formula
  desc "Webserver for dynamic content (written in Erlang)"
  homepage "http://yaws.hyber.org"
  url "https://github.com/klacke/yaws/archive/yaws-2.0.7.tar.gz"
  sha256 "083b1b6be581fdfb66d77a151bbb2fc3897b1b0497352ff6c93c2256ef2b08f6"
  head "https://github.com/klacke/yaws.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "251c2a89b97ccc6429991e24e2b3cefda0edb5a06fa33728f3a8e3e86870c02c" => :mojave
    sha256 "5320541b42c2d241771b92e721cb8296b04e6c71f71551cfcd41be17742067c3" => :high_sierra
    sha256 "9e93be437c866a3a674374443d4898fc94b7cd5be5d522843924f92294493c51" => :sierra
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
