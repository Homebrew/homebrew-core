class Ser2net < Formula
  desc "Allow network connections to serial ports"
  homepage "https://ser2net.sourceforge.io"
  url "https://downloads.sourceforge.net/project/ser2net/ser2net/ser2net-4.3.12.tar.gz"
  sha256 "6101bdf937716be9b019c721b28b45d21efddd1ec19ac935aad351c55bd6f83d"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/ser2net[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3e67b749975af9c7ea2781e0f8e82c181807ba20d7f2423a838102402373da0f"
    sha256 cellar: :any,                 arm64_monterey: "73ec3f6da5a019142ce8dc53647bdcb937c37d65f9b78d9cb084e5e0313dbfd4"
    sha256 cellar: :any,                 arm64_big_sur:  "81e7ae0d99307388fb6641e173cc629ca7b8bda0b4912545477c3dc830d04fa6"
    sha256 cellar: :any,                 ventura:        "f7ea421ff7406c33245f9582384107ba9e4a62e83c023421abab95a7d9f742ab"
    sha256 cellar: :any,                 monterey:       "55b1c30ba4dc0009740c62110ca725910b311b12d5b0e7008c78249fe49994b1"
    sha256 cellar: :any,                 big_sur:        "efc1fd194c98afc33b2ab52e24e828f1e67840f15519f9a52a63ff8273e2493c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19f8fe5bab56c3b9c63167266500869d26c3f6047aaa53afc277173c56fce63f"
  end

  depends_on "libyaml"

  resource "gensio" do
    url "https://downloads.sourceforge.net/project/ser2net/ser2net/gensio-2.6.3.tar.gz"
    sha256 "0220b55c9c4b86d70945cfca620f7a8fe36cfe0fc14308df993b4c4f17a433be"
  end

  def install
    resource("gensio").stage do
      system "./configure", "--disable-dependency-tracking",
                            "--prefix=#{libexec}/gensio",
                            "--with-python=no",
                            "--with-tcl=no"
      # Work around build failure (cannot find -lgensio: No such file or directory).
      ENV.deparallelize { system "make", "install" }
    end

    ENV.append_path "PKG_CONFIG_PATH", "#{libexec}/gensio/lib/pkgconfig"
    ENV.append_path "CFLAGS", "-I#{libexec}/gensio/include"
    ENV.append_path "LDFLAGS", "-L#{libexec}/gensio/lib"

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
