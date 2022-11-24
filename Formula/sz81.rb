class Sz81 < Formula
  desc "ZX80/81 emulator"
  homepage "https://sz81.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/sz81/sz81/2.1.7/sz81-2.1.7-source.tar.gz"
  sha256 "4ad530435e37c2cf7261155ec43f1fc9922e00d481cc901b4273f970754144e1"
  license "GPL-2.0"
  revision 1
  head "https://svn.code.sf.net/p/sz81/code/sz81"

  bottle do
    sha256 arm64_ventura:  "b69dac8446f5aa0d3939925eac7dc0b8ef904ee5b437b86600ac697a15bd80c2"
    sha256 arm64_monterey: "388474d15ee05fa83bb0517e807838b65b84ae022b7854ccd52cf5a8b8497926"
    sha256 arm64_big_sur:  "a0e1bf1c53a8d7412894cc05ea871514c3e2078bf1698551c78c74a9f02c66be"
    sha256 ventura:        "aa2af256cfba3c34e59449c8f80c452c11955abff1eacac534eb2db09beac044"
    sha256 monterey:       "2e4b260f47d8079aeda161b05533219e1074ed4e9ec8f8dbff8a495170d4e70a"
    sha256 big_sur:        "3fab5d79a3994f71580732051ab9cb927927388850d1323245720c638642e2e0"
    sha256 catalina:       "d5cf814d1ad80e3487bec11a5a1d79adef5dae89dc099c7ee2abef7ffe11e4db"
    sha256 x86_64_linux:   "99dd0e53ec8daf391aa95acda0fa68578248088e6ab944f5615607a18cddfd82"
  end

  depends_on "sdl12-compat"

  def install
    # Work around failure from GCC 10+ using default of `-fno-common`
    # /usr/bin/ld: common.o:(.bss+0x127e0): multiple definition of `sdl_zx80rom'
    ENV.append_to_cflags "-fcommon" if OS.linux?

    args = %W[
      PREFIX=#{prefix}
      BINDIR=#{bin}
    ]
    system "make", *args
    system "make", "install", *args
  end

  test do
    # Disable test on Linux because it fails with this error:
    # sdl_init: Cannot initialise SDL: No available video device
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match "sz81 #{version} -", shell_output("#{bin}/sz81 -h", 1)
  end
end
