class Rinetd < Formula
  desc "Internet TCP redirection server"
  homepage "https://github.com/samhocevar/rinetd"
  url "https://github.com/samhocevar/rinetd/releases/download/v0.70/rinetd-0.70.tar.bz2"
  sha256 "cefe9115c57fe5ec98d735f6421f30c461192e345a46ef644857b11fa6c5fccb"
  license "GPL-2.0-or-later"
  # NOTE: Original (unversioned) tool is at https://github.com/boutell/rinetd
  #       Debian tracks the "samhocevar" fork so we follow suit
  head "https://github.com/samhocevar/rinetd"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "3b5b6e687790fd0d6167cf42ce89baeb895acb4a66b1bf8451cfe5e46bb45e0a" => :big_sur
    sha256 "d5e98fb2a9a9d85a92e5efb8dfed1e64f38a97c2c0e0de7c86cca30e1ad6ba70" => :arm64_big_sur
    sha256 "530373c4f2c88c0ddf3463733fba78776d22f7640d952db496104147d55d2275" => :catalina
    sha256 "bdac7c623c5c49367b11a16dea5661f99fd5130fbea10973cc15842a1284d1b1" => :mojave
  end

  def install
    # The daemon() function does exist but its deprecated so keep configure
    # away:
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{share}", "ac_cv_func_daemon=no"

    # Point hardcoded runtime paths inside of our prefix
    inreplace "rinetd.h" do |s|
      s.gsub! "/etc/rinetd.conf", "#{etc}/rinetd.conf"
      s.gsub! "/var/run/rinetd.pid", "#{var}/run/rinetd.pid"
    end
    inreplace "rinetd.conf", "/var/log", "#{var}/log"

    # Install conf file only as example and have post_install put it into place
    mv "rinetd.conf", "rinetd.conf.example"
    inreplace "Makefile", "rinetd.conf", "rinetd.conf.example"

    system "make", "install"
  end

  def post_install
    conf = etc/"rinetd.conf"
    cp "#{share}/rinetd.conf.example", conf unless conf.exist?
  end

  test do
    system "#{sbin}/rinetd", "-h"
  end
end
