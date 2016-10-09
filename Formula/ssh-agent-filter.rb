class SshAgentFilter < Formula
  desc "filtering proxy for ssh-agent"
  homepage "https://github.com/tiwe-de/ssh-agent-filter"
  url "https://github.com/tiwe-de/ssh-agent-filter/archive/0.4.2.tar.gz"
  sha256 "5586e40da34f4afd873d7ff30f115c4a1b9455c1b81f3c4679c995db7615b080"

  depends_on "help2man" => :build
  depends_on "boost"
  depends_on "nettle"

  patch :DATA

  def install
    ENV.deparallelize
    system "make", "ssh-agent-filter.1"
    man1.install "ssh-agent-filter.1"
    bin.install "ssh-agent-filter"
    bin.install "afssh"
  end

  test do
    (testpath/"test.sh").write <<-EOS.undent
      mydir=$(pwd)
      cd $(mktemp -d)
      ssh-keygen -q -N '' -f keyA
      ssh-keygen -q -N '' -f keyB
      eval $(ssh-agent)
      pid=$SSH_AGENT_PID
      ssh-add keyA
      ssh-add keyB
      sha1=$(ssh-add -l | awk '/keyA/{print $2}')
      eval $(ssh-agent-filter -c keyA)
      sha2=$(ssh-add -l | awk '{print $2}')
      kill $SSH_AGENT_PID $pid 
      test "$sha1" == "$sha2"
    EOS
    system "sh", "test.sh"
  end
end
__END__
Fix afssh https://github.com/tiwe-de/ssh-agent-filter/pull/5#issuecomment-242216945
Fix man page generation due to missing perl Locale::gettext
diff --git a/afssh b/afssh
index c482aea..6c2fbdf 100755
--- a/afssh
+++ b/afssh
@@ -52,7 +52,7 @@ fi
 declare -a agent_filter_args
 
 if [ -x "${BASH_SOURCE%/*}/ssh-agent-filter" ]; then
-	SAF=$(readlink -f "${BASH_SOURCE%/*}/ssh-agent-filter")
+	SAF=$(realpath "${BASH_SOURCE%/*}/ssh-agent-filter")
 else
 	SAF=$(which ssh-agent-filter)
 fi
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
 
