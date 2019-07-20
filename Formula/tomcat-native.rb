class TomcatNative < Formula
  desc "Lets Tomcat use some native resources for performance"
  homepage "https://tomcat.apache.org/native-doc/"
  url "https://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-connectors/native/1.2.23/source/tomcat-native-1.2.23-src.tar.gz"
  mirror "https://archive.apache.org/dist/tomcat/tomcat-connectors/native/1.2.23/source/tomcat-native-1.2.23-src.tar.gz"
  sha256 "5ae5940f759cfdd68384ecf61f2c4fd9b01eb430ab0d349c0b197df0b0c0c3c7"

  bottle do
    cellar :any
    sha256 "3d37f4f0edaa55674c3f4a0df9592d9dbf397ee21347fe7a09d53ee765a8fa36" => :mojave
    sha256 "6df50a56e9c18cf7d25e3a16e2206d1b535ee53ce4c5574c8bcde75a0e5ed822" => :high_sierra
    sha256 "883a53d75d7e4f7a2de85304cc72d0b1fe0d8fd58d5fa126fde4e65049f10f8f" => :sierra
  end

  depends_on "libtool" => :build
  depends_on "apr"
  depends_on :java => "1.7+"
  depends_on "openssl"
  depends_on "tomcat"

  def install
    cd "native" do
      system "./configure", "--prefix=#{prefix}",
                            "--with-apr=#{Formula["apr"].opt_prefix}",
                            "--with-java-home=#{ENV["JAVA_HOME"]}",
                            "--with-ssl=#{Formula["openssl"].opt_prefix}"

      # fixes occasional compiling issue: glibtool: compile: specify a tag with `--tag'
      args = ["LIBTOOL=glibtool --tag=CC"]
      # fixes a broken link in mountain lion's apr-1-config (it should be /XcodeDefault.xctoolchain/):
      # usr/local/opt/libtool/bin/glibtool: line 1125: /Applications/Xcode.app/Contents/Developer/Toolchains/OSX10.8.xctoolchain/usr/bin/cc: No such file or directory
      args << "CC=#{ENV.cc}"
      system "make", *args
      system "make", "install"
    end
  end

  def caveats; <<~EOS
    In order for tomcat's APR lifecycle listener to find this library, you'll
    need to add it to java.library.path. This can be done by adding this line
    to $CATALINA_HOME/bin/setenv.sh

      CATALINA_OPTS=\"$CATALINA_OPTS -Djava.library.path=#{opt_lib}\"

    If $CATALINA_HOME/bin/setenv.sh doesn't exist, create it and make it executable.
  EOS
  end
end
