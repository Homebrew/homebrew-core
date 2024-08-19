class Sshguard < Formula
  desc "Protect from brute force attacks against SSH"
  homepage "https://www.sshguard.net/"
  url "https://downloads.sourceforge.net/project/sshguard/sshguard/2.4.3/sshguard-2.4.3.tar.gz"
  sha256 "64029deff6de90fdeefb1f497d414f0e4045076693a91da1a70eb7595e97efeb"
  license "ISC"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dfcd69dfa51b4976cfbd022ba196c47e5e2d78059ffe90db19dd3c66c72eb3d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d1f7f154a01ba3ba3e1ef3862f0ea18c2460184686dce1129b1ccc0b6dd6231e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ad5eef11b004af2258151a03ee2b9802267be357da3c14e0c4cf104294d1085"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d3662f3a27292d8a40abb8645eed33d17ee718c877d419c61e3f44020a49a712"
    sha256 cellar: :any_skip_relocation, sonoma:         "723b522af26e5582a342587180df22e7ee0d131250569ddb155c71c937bd9b08"
    sha256 cellar: :any_skip_relocation, ventura:        "65fce1b8916c1e589e329fd991de5d55abf25dabcd87ae6cd444a458bb4ac3f0"
    sha256 cellar: :any_skip_relocation, monterey:       "cb3e4ad746aa9eb9d840fd332a98fe60fd71632fdf28f90e21f643dd3d92bb03"
    sha256 cellar: :any_skip_relocation, big_sur:        "8fe1ac17002be39b5b190d1d98822ce397740e032cdaee6994ded17af59c954a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "293288f8ed572eadf951168a526824663f6a4193d1a04d6b487fd41478b0ace5"
  end

  head do
    url "https://bitbucket.org/sshguard/sshguard.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "docutils" => :build
  end

  def install
    system "autoreconf", "-fiv" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make", "install"
    inreplace man8/"sshguard.8", "%PREFIX%/etc/", "#{etc}/"
    cp "examples/sshguard.conf.sample", "examples/sshguard.conf"
    inreplace "examples/sshguard.conf" do |s|
      s.gsub!(/^#BACKEND=.*$/, "BACKEND=\"#{opt_libexec}/sshg-fw-pf\"")
      if OS.mac? && MacOS.version >= :sierra
        s.gsub! %r{^#LOGREADER="/usr/bin/log}, "LOGREADER=\"/usr/bin/log"
      else
        s.gsub!(/^#FILES.*$/, "FILES=/var/log/system.log")
      end
    end
    etc.install "examples/sshguard.conf"
  end

  def caveats
    <<~EOS
      Add the following lines to /etc/pf.conf to block entries in the sshguard
      table (replace $ext_if with your WAN interface):

        table <sshguard> persist
        block in quick on $ext_if proto tcp from <sshguard> to any port 22 label "ssh bruteforce"

      Then run sudo pfctl -f /etc/pf.conf to reload the rules.
    EOS
  end

  service do
    run [opt_sbin/"sshguard"]
    keep_alive true
    require_root true
  end

  test do
    require "pty"
    PTY.spawn(sbin/"sshguard", "-v") do |r, _w, pid|
      assert_equal "SSHGuard #{version}", r.read.strip
    rescue Errno::EIO
      nil
    ensure
      Process.wait pid
    end
  end
end
