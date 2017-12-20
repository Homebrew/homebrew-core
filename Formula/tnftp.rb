class Tnftp < Formula
  desc "NetBSD's FTP client (built from macOS Sierra sources)"
  homepage "https://opensource.apple.com/"
  url "https://opensource.apple.com/tarballs/lukemftp/lukemftp-16.tar.gz"
  version "20070806"
  sha256 "ba35a8e3c2e524e5772e729f592ac0978f9027da2433753736e1eb1f1351ae9d"

  keg_only :provided_pre_high_sierra

  depends_on :xcode => :build

  conflicts_with "inetutils", :because => "both install `ftp' binaries"

  def install
    # Trying to use Apple's pre-supplied Makefile resulted
    # in headaches... they have made the build process
    # specifically for installing to /usr/bin and so it
    # just doesn't play well with homebrew.

    # so just build straight from ftp's own sources
    # from the extracted 20070806 tarball which have
    # already been patched
    cd "tnftp" do
      system "./configure"
      system "make", "all"
      system "strip", "-x", "src/ftp" # this is done in Apple's `post-install` target

      bin.install "src/ftp"
      man1.install "src/ftp.1"
      prefix.install_metafiles
    end
  end

  test do
    require "pty"
    require "expect"

    PTY.spawn "#{bin}/ftp ftp://anonymous:none@speedtest.tele2.net" do |input, output, _pid|
      str = input.expect(/Connected to speedtest.tele2.net./)
      output.puts "exit"
      assert_match "Connected to speedtest.tele2.net.", str[0]
    end
  end
end
