class SshAgentFilter < Formula
  desc "filtering proxy for ssh-agent"
  homepage "https://github.com/tiwe-de/ssh-agent-filter"
  url "https://github.com/tiwe-de/ssh-agent-filter/archive/0.4.2.tar.gz"
  sha256 "5586e40da34f4afd873d7ff30f115c4a1b9455c1b81f3c4679c995db7615b080"

  depends_on "help2man" => :build
  depends_on "pandoc" => :build 
  depends_on "boost"
  depends_on "nettle"

  patch do
    # https://github.com/tiwe-de/ssh-agent-filter/pull/6
    url "https://patch-diff.githubusercontent.com/raw/tiwe-de/ssh-agent-filter/pull/6.diff"
    sha256 "073b6d45694b547c6067403d4f657d4dfa2819926c386ecea131a1499403dd30"
  end

  resource "Locale::gettext" do
    url "https://cpan.metacpan.org/authors/id/P/PV/PVANDRY/gettext-1.07.tar.gz"
    sha256 "909d47954697e7c04218f972915b787bd1244d75e3bd01620bc167d5bbc49c15"
  end

  def install
   resource("Locale::gettext").stage do
     system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
     system "make", "install"
   end
   system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    gencmd = ["ssh-keygen", "-q", "-N", "", "-t" "ed25519"]
    system *gencmd, "-C", "keyA", "-f", "keyA"
    system *gencmd, "-C", "keyB", "-f", "keyB"
    (testpath/"test.sh").write <<-EOS.undent
      eval $(ssh-agent)
      pid=$SSH_AGENT_PID
      ssh-add keyA keyB
      sha1=$(ssh-add -l | awk '/keyA/{print $2}')
      eval $(ssh-agent-filter -c keyA)
      sha2=$(ssh-add -l | awk '{print $2}')
      kill $SSH_AGENT_PID $pid 
      test "$sha1" = "$sha2"
    EOS
    system "sh", "test.sh"
  end
end
