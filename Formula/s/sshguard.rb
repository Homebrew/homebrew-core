class Sshguard < Formula
  desc "Protect from brute force attacks against SSH"
  homepage "https://www.sshguard.net/"
  url "https://downloads.sourceforge.net/project/sshguard/sshguard/2.5.1/sshguard-2.5.1.tar.gz"
  sha256 "997a1e0ec2b2165b4757c42f8948162eb534183946af52efc406885d97cb89fc"
  license "ISC"
  version_scheme 1

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e9518ae9f10154dcc84c9f1348b436a49ebb0b59d07982c468d0edad7cc38cdd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0f56a4e44504c78bf201cbb62b0d01d1ab2fcf1149e6dcc6e7562fb41c0ac99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11ef33ea3f5e54e448b493db07993839407bd6e62fd50ed3b7feaae74f0419f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1d3904d7dfa3b416126cd6f3088fd21eea79ac94af8cf5c6c787af6a27f8ba1e"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c22c01d6e11c18443e9d3a12b5e858f5468c8da4f0aba9f716b054267a631de"
    sha256 cellar: :any_skip_relocation, ventura:       "8c7e0ca50223efc082c428aad1e0d62fda73f55d9cf280f7255f7228093917a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28355a7f475cfaa5092312e781333f17718098181707052e90fc97f2dea8deff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22338d5f5ba21e11cbccca5dc0e2bc860d39d5f7822c5e1e3e43835e722456a2"
  end

  head do
    url "https://bitbucket.org/sshguard/sshguard.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "docutils" => :build
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", "--disable-silent-rules", "--sysconfdir=#{etc}", *std_configure_args
    system "make", "install"
    inreplace man8/"sshguard.8", "%PREFIX%/etc/", "#{etc}/"
    cp "examples/sshguard.conf.sample", "examples/sshguard.conf"
    inreplace "examples/sshguard.conf" do |s|
      s.gsub!(/^#BACKEND=.*$/, "BACKEND=\"#{opt_libexec}/sshg-fw-pf\"")
      if OS.mac?
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
