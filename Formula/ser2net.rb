class Ser2net < Formula
  desc "Allow network connections to serial ports"
  homepage "https://ser2net.sourceforge.io"
  url "https://downloads.sourceforge.net/project/ser2net/ser2net/ser2net-4.3.11.tar.gz"
  sha256 "8f831f11b67538280aa0e8787cb0785ff705cf90749aa175d32c337f29412ae3"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/ser2net[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0cd19c4d51f4229a049fa9590ee8cc1c9c473cbbf249a3147ee37ba3ef552c68"
    sha256 cellar: :any,                 arm64_monterey: "a08aea19b56221d59e84f89d93a374bbf273b72bf66a885e0cc40261c30c9337"
    sha256 cellar: :any,                 arm64_big_sur:  "57058315827d56c4fccf3e203895ec60e6191a250b3c65beee42f570bf6f4599"
    sha256 cellar: :any,                 ventura:        "dd9787b852f531524268269830a4cdbd463a10549825d2ea6f22bf80342e67f6"
    sha256 cellar: :any,                 monterey:       "2a7f2f26850a05d31b6db0ff196d9baaaca00b70cf62119467476cbde8559661"
    sha256 cellar: :any,                 big_sur:        "cd79c15831a196c95faab70f4a1d158917f293ac7dbbaa71c72b72e4d2b48890"
    sha256 cellar: :any,                 catalina:       "b796023b7cbe8d52c775b0d7dc6afaf32d2b89859b9db0b1fd464db6d37ce37d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0be86f82493afe39e6af69ea4a948d821cee1595f054c657ea487779e8846b5f"
  end

  depends_on "libyaml"

  resource "gensio" do
    url "https://downloads.sourceforge.net/project/ser2net/ser2net/gensio-2.4.1.tar.gz"
    sha256 "949438b558bdca142555ec482db6092eca87447d23a4fb60c1836e9e16b23ead"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  def install
    resource("gensio").stage do
      system "./configure", "--disable-dependency-tracking",
                            "--prefix=#{libexec}/gensio",
                            "--with-python=no",
                            "--with-tcl=no"
      system "make", "install"
    end

    ENV.append_path "PKG_CONFIG_PATH", "#{libexec}/gensio/lib/pkgconfig"
    ENV.append_path "CFLAGS", "-I#{libexec}/gensio/include"
    ENV.append_path "LDFLAGS", "-L#{libexec}/gensio/lib"

    if OS.mac?
      # Patch to fix compilation error
      # https://sourceforge.net/p/ser2net/discussion/90083/thread/f3ae30894e/
      # Remove with next release
      inreplace "addsysattrs.c", "#else", "#else\n#include <gensio/gensio.h>"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"

    (etc/"ser2net").install "ser2net.yaml"
  end

  def caveats
    <<~EOS
      To configure ser2net, edit the example configuration in #{etc}/ser2net/ser2net.yaml
    EOS
  end

  service do
    run [opt_sbin/"ser2net", "-p", "12345"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/ser2net -v")
  end
end
