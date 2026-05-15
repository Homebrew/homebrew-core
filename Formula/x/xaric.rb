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
    rebuild 2
    sha256 arm64_tahoe:   "28872c99390c2300d6378440d8e060f769ab078e46c9e94a71890b0889d0a409"
    sha256 arm64_sequoia: "97f67bb569cb2956953e6b36fda5652e6102304962f9342bab5328d9e16a73ad"
    sha256 arm64_sonoma:  "f85f7887576b2b971caab0247fc1e9dd7dc0c8ff3bd9df731564ae9a5cc3f7cf"
    sha256 sonoma:        "01c3409aaf6f70234eb46227f93011a4304a5d0db483cc93699ed67b8314f1e1"
    sha256 arm64_linux:   "4e5a4883340539ac88a7ab2fc160d92eaf49af6abef2fca8dd217e65d30afb90"
    sha256 x86_64_linux:  "79f59d62efb2fe4cccee741c6a50431596985b700547d2ef333545ec087237ef"
  end

  depends_on "openssl@4"

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
    # Workaround for newer Clang
    ENV.append_to_cflags "-Wno-implicit-int" if DevelopmentTools.clang_build_version >= 1403

    system "./configure", "--with-openssl=#{Formula["openssl@4"].opt_prefix}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    require "pty"
    output = ""
    PTY.spawn(bin/"xaric", "-v") do |r, _w, _pid|
      r.each_line { |line| output += line }
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
    assert_match "Xaric #{version}", output
  end
end
