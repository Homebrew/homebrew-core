class SshAgentFilter < Formula
  desc "filtering proxy for ssh-agent"
  homepage "https://github.com/tiwe-de/ssh-agent-filter"
  url "https://github.com/tiwe-de/ssh-agent-filter/archive/0.4.2.tar.gz"
  sha256 "5586e40da34f4afd873d7ff30f115c4a1b9455c1b81f3c4679c995db7615b080"

  depends_on "help2man" => :build
  depends_on "boost"
  depends_on "nettle"

  patch do
    # upstream didn't want this because realpath isn't included in coreutils for Debian wheezy.
    # see https://github.com/tiwe-de/ssh-agent-filter/pull/5
    url "https://patch-diff.githubusercontent.com/raw/tiwe-de/ssh-agent-filter/pull/5.diff"
    sha256 "307ccd6e872a3f3b999d8a4368d152dfbd3a7e43b4cff0cacbc0390c78b2976b"
  end

  patch do
    # https://github.com/tiwe-de/ssh-agent-filter/pull/6
    url "https://patch-diff.githubusercontent.com/raw/tiwe-de/ssh-agent-filter/pull/6.diff"
    sha256 "5bd81db7cbfaf04e681f343ef6742061eaf6c9ead7d30c3fe6bf98eb8690c32f"
  end

  patch :DATA

  def install
   system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.sh").write <<-EOS.undent
      cd $(mktemp -d)
      ssh-keygen -q -N '' -t ed25519 -C keyA -f keyA
      ssh-keygen -q -N '' -t ed25519 -C keyB -f keyB
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
__END__
Fix man page generation due to missing perl Locale::gettext
diff --git a/Makefile b/Makefile
index b2e05ec..30b3e9f 100644
--- a/Makefile
+++ b/Makefile
@@ -28,7 +28,7 @@ all: ssh-agent-filter.1 afssh.1 ssh-askpass-noinput.1
 	pandoc -s -w man $< -o $@
 
 %.1: %.help2man %
-	help2man -i $< -o $@ -N -L C.UTF-8 $(*D)/$(*F)
+	help2man -i $< -o $@ -N $(*D)/$(*F)
 
 ssh-agent-filter: ssh-agent-filter.o
 
