class Xaric < Formula
  desc "IRC client"
  homepage "https://xaric.org/"
  url "https://xaric.org/software/xaric/releases/xaric-0.13.9.tar.gz"
  sha256 "cb6c23fd20b9f54e663fff7cab22e8c11088319c95c90904175accf125d2fc11"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://xaric.org/software/xaric/releases/"
    regex(/href=.*?xaric[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "38088b4ae12add10906e733b77f6fc7c7ce0482af1bbd71e6e03db6351c934b7"
    sha256 arm64_monterey: "448f66a8156857d38d4050fc9f062d8a6bc9f9267b85a063acc776095635bc19"
    sha256 arm64_big_sur:  "9f38a153d2c80701856c14b0bbdc776c9d50ab1f0930b668f2e3f7c377b4ecac"
    sha256 ventura:        "b46f72b6bad580eeb6583455155d8427e8c2812a5e87fe88975fdf5261e10982"
    sha256 monterey:       "d71030b64a334132691fae5896e5924428138fa2de5bed1634cbcf22d625bedf"
    sha256 big_sur:        "98a7bcefda0b4262da3bfbb45fe6985fae25db911cc60ea33b503be4e4598bed"
    sha256 catalina:       "74bf2f31d52f8057a22fd38858314668cd62b89adad5a299209890a717718856"
    sha256 x86_64_linux:   "633be739d85e31a8d4e7af822a11a8c07f30c0491035fb76cd68f3b81145940b"
  end

  depends_on "openssl@3"

  uses_from_macos "ncurses"

  # Fix ODR violations (waiting for the PR accepted)
  patch do
    url "https://github.com/laeos/xaric/commit/a6fa3936918098fd00ebcfb845360a6110ac4505.patch?full_index=1"
    sha256 "353ef73a5a408a876f99d4884a7d5c74d06759c60a786ef7c041ca7d8e0abcd3"
  end

  # Fix ODR violations pt.2 (waiting for the PR accepted)
  patch do
    url "https://github.com/laeos/xaric/commit/c365b700a5525cf0a38091c833096c179ee2e40f.patch?full_index=1"
    sha256 "9e82b5df90b96b096a3556afc3520e7b3e8d649eed4b8b42be622bc428f0ca73"
  end

  def install
    system "./configure", *std_configure_args,
                          "--with-openssl=#{Formula["openssl@3"].opt_prefix}"
    system "make", "install"
  end

  test do
    require "pty"
    output = ""
    PTY.spawn("#{bin}/xaric", "-v") do |r, _w, _pid|
      r.each_line { |line| output += line }
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
    assert_match "Xaric #{version}", output
  end
end
