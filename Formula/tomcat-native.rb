class TomcatNative < Formula
  desc "Lets Tomcat use some native resources for performance"
  homepage "https://tomcat.apache.org/native-doc/"
  url "https://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-connectors/native/1.2.12/source/tomcat-native-1.2.12-src.tar.gz"
  mirror "https://archive.apache.org/dist/tomcat/tomcat-connectors/native/1.2.12/source/tomcat-native-1.2.12-src.tar.gz"
  sha256 "e7add177c98a7f07220c306d65e182c45dbcd7501115e9ed56f1690c5472ded9"

  bottle do
    cellar :any
    sha256 "a0b320aad5f81322a9f362811375a8f2bf71c9acbe2552af14d180a41953f01d" => :sierra
    sha256 "f948df2f5f5ce08dcae517e0543ec79b275fa995f6631a561c2e010b09476688" => :el_capitan
    sha256 "0de939cf4b43bba2bca9044fac764068deb8ce91c2060bf76732e7444f963ec1" => :yosemite
  end

  depends_on "libtool" => :build
  depends_on "tomcat" => :recommended
  depends_on :java => "1.7+"
  depends_on "openssl"
  depends_on "apr"

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
      args << "CC=#{ENV.cc}" if MacOS.version >= :mountain_lion
      system "make", *args
      system "make", "install"
    end
  end

  def caveats; <<-EOS.undent
    In order for tomcat's APR lifecycle listener to find this library, you'll
    need to add it to java.library.path. This can be done by adding this line
    to $CATALINA_HOME/bin/setenv.sh

      CATALINA_OPTS=\"$CATALINA_OPTS -Djava.library.path=#{lib}\"

    If $CATALINA_HOME/bin/setenv.sh doesn't exist, create it and make it executable.
    EOS
  end
end
