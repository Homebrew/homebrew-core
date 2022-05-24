class Rinetd < Formula
  desc "Internet TCP redirection server"
  homepage "https://github.com/samhocevar/rinetd"
  url "https://github.com/samhocevar/rinetd/releases/download/v0.73/rinetd-0.73.tar.bz2"
  sha256 "24dd6ec1c4d353c33ced775a37566af9565b27e65f3e59939a8b2913a92c81d2"
  license "GPL-2.0-or-later"
  # NOTE: Original (unversioned) tool is at https://github.com/boutell/rinetd
  #       Debian tracks the "samhocevar" fork so we follow suit
  head "https://github.com/samhocevar/rinetd.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef5f8967db4460b4c330a1b53488b7ac0a2777c06b9120be0dc24f78f25d8825"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e4f668d5feb5299fa1de94c4b0335ab3e36b5ac1238ccb4519cff25be103dea5"
    sha256 cellar: :any_skip_relocation, monterey:       "c1f9f4491c8a64cb38e72705a74b0ea0eb4b66ab49f80b253cf6ec6b7b6c5aa5"
    sha256 cellar: :any_skip_relocation, big_sur:        "b73d5f5a82ad3371107eab67403b888e7e9e6f19f3c99909c8c72401a680c396"
    sha256 cellar: :any_skip_relocation, catalina:       "f2f6a19fcfc01cfde67148410a6bcf81c861fb373e860210e32294cb9df4fbcc"
    sha256 cellar: :any_skip_relocation, mojave:         "6a6f22a6081ac2dff01ca89a256a21c991a6f2171f2703b08e2acbd0d8c177a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fadcdad114c33040c9ca301f74a84d301eecf67b3ff722ddce9b8fbfac395399"
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
