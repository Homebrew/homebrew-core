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
    sha256 arm64_monterey: "0679cb45a723581f21bd4295225c92e01a303155e772e07ad598303d8d3acff0"
    sha256 arm64_big_sur:  "9f89bb7adc21f31a7721a5b3cc0586820cc59e50e82f6316ef74f2dbce1c512f"
    sha256 monterey:       "914abc6071ee13379b8238fac06093d1e35277d1b36365ad346bc75dc7ee688c"
    sha256 big_sur:        "4c9e9e9d0ef2e7f5c8bb8996ef72220f2315e756e1a4c9c8e23869b8e0abc84e"
    sha256 catalina:       "5438f46156ba60b6658275aefdda7617296691d949f7dd0f85dcdac1225d254e"
    sha256 mojave:         "e8c40aad03fec80e9566a1bb9c7100cbb3a4e0fca3dbc9f79f65271d3e29631f"
    sha256 x86_64_linux:   "407b5776d290e11fa9dc958d03d7035c623ff5876bc2f2fa37de4462f9f6547d"
  end

  depends_on "openssl@1.1"

  uses_from_macos "ncurses"

  def install
    system "./configure", *std_configure_args,
                          "--with-openssl=#{Formula["openssl@1.1"].opt_prefix}"
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
