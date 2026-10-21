class Sshguard < Formula
  desc "Protect from brute force attacks against SSH"
  homepage "https://www.sshguard.net/"
  url "https://downloads.sourceforge.net/project/sshguard/sshguard/2.6.0/sshguard-2.6.0.tar.gz"
  sha256 "17cf44e29ce7853bd2df1425785947a097eda1d4f87ffb03a92d4c98bae4654d"
  license "ISC"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a599097cf3d467ae7d5e47c1764d7e34317ce7a0874010f8cc2e2aacac191540"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "67daea1302f4a4f3f9bb989c0d858b92ede6efbb1f52f19267ddd3f27c0325bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3079d307e121aac95c5afcf5935e2c8402c8127bb6919d6b43df1befa145eced"
    sha256 cellar: :any,                 arm64_linux:       "950cd0e4cea4cda3ec1e0d85166a5ac7afa96a6a552241f657db79b5bb07e420"
    sha256 cellar: :any,                 x86_64_linux:      "5a6145efdf01e865cbee5475e15ad63dab94265e169050e49336d2aa05f052b3"
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
