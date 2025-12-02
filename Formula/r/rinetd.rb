class Rinetd < Formula
  desc "Internet TCP redirection server"
  homepage "https://github.com/samhocevar/rinetd"
  url "https://github.com/samhocevar/rinetd/releases/download/v0.73/rinetd-0.73.tar.bz2"
  sha256 "39180d31b15f059b2e876496286356e40183d1567c2e2aec41aacad8721ecc44"
  license "GPL-2.0-or-later"
  revision 1
  # NOTE: Original (unversioned) tool is at https://github.com/boutell/rinetd
  #       Debian tracks the "samhocevar" fork so we follow suit
  head "https://github.com/samhocevar/rinetd.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "ac09912351ca2587bbea4572cbc2d5101d93b14a1ccf925cff8cfa83aedf5128"
    sha256 arm64_sequoia: "1bbfcadccec37315d56385b18334084654fa2176c6b8c6f11c4a059be3541acd"
    sha256 arm64_sonoma:  "1ca5c0b84ac7749459a50478734f32ccc256f092aec9322400963f87d2a1dbdf"
    sha256 sonoma:        "e6c5ecca7be62f96837669443c191fdfebeb2872f936750814eda3bda0082a51"
    sha256 arm64_linux:   "385446c42d6820a00d85ca5793a341ebeb20e32390bba72876ea6156056142ba"
    sha256 x86_64_linux:  "b261f72637835eb98ed1773e236c664160528346a77e65fabef294766809def5"
  end

  def install
    # The daemon() function does exist but its deprecated so keep configure
    # away:
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{share}", "ac_cv_func_daemon=no"

    # Point hardcoded runtime paths inside of our prefix
    inreplace "src/rinetd.h" do |s|
      s.gsub! "/etc/rinetd.conf", "#{etc}/rinetd.conf"
      s.gsub! "/var/run/rinetd.pid", "#{var}/run/rinetd.pid"
    end
    inreplace "rinetd.conf", "/var/log", "#{var}/log"

    # Install conf file only as example and let etc.install handle existing config
    cp "rinetd.conf", "rinetd.conf.example"
    etc.install "rinetd.conf"
    inreplace "Makefile", "rinetd.conf", "rinetd.conf.example"

    system "make", "install"
  end

  test do
    system sbin/"rinetd", "-h"
  end
end
