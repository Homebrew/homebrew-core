class Sshguard < Formula
  desc "Protect from brute force attacks against SSH"
  homepage "https://www.sshguard.net/"
  url "https://downloads.sourceforge.net/project/sshguard/sshguard/2.4.2/sshguard-2.4.2.tar.gz"
  sha256 "2770b776e5ea70a9bedfec4fd84d57400afa927f0f7522870d2dcbbe1ace37e8"
  license "ISC"
  version_scheme 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "432b5c348a85223ac41b4ff38a1416847227c74e3372ddb1aeb1575612421dbb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9d878d2defd31509f5248eb407a15b358e1b5e78e317cb4ecb58ea971eb0e21f"
    sha256 cellar: :any_skip_relocation, monterey:       "223206d74a0c9637ef21524dd7031262fad932ec9edd60996cf88272eff27e19"
    sha256 cellar: :any_skip_relocation, big_sur:        "fbd36be947e48cf8617b3889334ac8c0941b51e03b4c5193027791a727588999"
    sha256 cellar: :any_skip_relocation, catalina:       "02f3958ed46f151af475f82d9056fd4ba2d7cc6992f95d5ee35351ec0091256e"
    sha256 cellar: :any_skip_relocation, mojave:         "ceeba24a2d30a5832d77dcdac07234d693294053198efefc220125b14082c0ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97303dd520d97f9dc3f9e66462093c982663df097e0665c9cba4bbdb9e3eefc6"
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
      if MacOS.version >= :sierra
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

  plist_options startup: true
  service do
    run [opt_sbin/"sshguard"]
    keep_alive true
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
