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

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "1aa4fa0021a1509710ef1b13f7e76d7ec8b1f819f941835040807ce8255599d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b64c37c93190bdea6d086f34832b7db19ee69cd22ce7046e6c371a0c6b292a22"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8de3030cc0499320d112d4d07a4379a4068efab0c5b7e027d7f4a45be33d1d6a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35efe356153b47c973f2548d1b02c27c503dbc6cc360bec5eaa60a94049b5dbd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3be0837da2a86dc6453bbb3ca1169d3ba321cf04190128215f3b6ce6aba4cb21"
    sha256 cellar: :any_skip_relocation, sonoma:         "2c97ad9b664fc28f0da87ef9e5bad45f8f667f952886f4b441be9144b1ec4401"
    sha256 cellar: :any_skip_relocation, ventura:        "a3ab75f17f3d2d80dc139d9ed8a380cef57fe6c759520ec31056d0d60a84054d"
    sha256 cellar: :any_skip_relocation, monterey:       "28ee184db1c28e98eecca90ae1e2df0bf8af20c1810675a4298d31d803f6053c"
    sha256 cellar: :any_skip_relocation, big_sur:        "90b5e423280f7ed15989bcea13980ec6bbc5ba2071958236f2b5a52ee55d24c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "3836623c7c45410071cda84c136d8455fe6c0d3efc171baedd20eebf18606b29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c938efa3c89e08edc1063d301e41ec8fb026e28da8b956f7e9fde90efa4ff835"
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
