class TomcatNative < Formula
  desc "Lets Tomcat use some native resources for performance"
  homepage "https://tomcat.apache.org/native-doc/"
  url "https://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-connectors/native/1.2.19/source/tomcat-native-1.2.19-src.tar.gz"
  mirror "https://archive.apache.org/dist/tomcat/tomcat-connectors/native/1.2.19/source/tomcat-native-1.2.19-src.tar.gz"
  sha256 "95c91d17907b321f3abe8799bd73bf32b544dd12ff59bcb3eb7db584bbf65f63"

  bottle do
    cellar :any
    rebuild 1
    sha256 "f33bee57406b4046e6b8ab8c4d214c7c2c03edeb797440570646e4c4bd1c2346" => :mojave
    sha256 "ad856715f0f03622f10df6b090069d5ea2dd7472056133d00b4c74bf6be62ea2" => :high_sierra
    sha256 "87c67f203543576408082aa94f9abde64372bff2bcf635610eda83e4801b2939" => :sierra
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
      args << "CC=#{ENV.cc}" if MacOS.version >= :mountain_lion
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
