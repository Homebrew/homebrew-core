class Rsdns < Formula
  desc "Rackspace Cloud DNS CLI"
  homepage "https://github.com/linickx/rsdns"
  url "https://github.com/linickx/rsdns/archive/v4.0.tar.gz"
  sha256 "060bea37a85c9debe59bb23c8a4326e97ced04fe3de15689e34123c978dffb99"
  head "https://github.com/linickx/rsdns.git"

  depends_on "jq"
  bottle :unneeded

  # This package is essentially a web of shell script that all expect their
  # friends to be in some particular location. Fixing that upstream to be more
  # homebrew friendly is a lot of work compared to the simple patch that can
  # workaround this.
  patch :DATA

  def install
    libexec.install Dir["rsdns-*.sh"]
    lib.install "lib/auth.sh", "lib/func.sh"
    bin.install "rsdns"
  end

  def caveats
    <<-EOS.undent
      Rackspace Cloud credentials can be saved in ~/.rsdns_config. See #{prefix}/README.md for info.
    EOS
  end

  test do
    # this will cause it to find and exec all the scripts in libexec. Can't do
    # much else without API credentials.
    system bin/"rsdns"
  end
end

__END__
diff --git a/rsdns b/rsdns
index 9b4fe92..6cedcae 100755
--- a/rsdns
+++ b/rsdns
@@ -9,8 +9,11 @@ do
     FILELOCATION=$(readlink "$FILELOCATION")
 done

-LOCATION=$(dirname "$FILELOCATION")
+RSPATH="$(dirname $0)/$(dirname $(dirname "$FILELOCATION"))"
+LOCATION="$RSPATH/libexec"
+export RSPATH
 COMMAND=$1
+export RSPATH="$LOCATION/.."
 if [ "$COMMAND" ]
 then
     shift
