class TomcatNative < Formula
  desc "Lets Tomcat use some native resources for performance"
  homepage "https://tomcat.apache.org/native-doc/"
  url "https://www.apache.org/dyn/closer.lua?path=tomcat/tomcat-connectors/native/1.2.26/source/tomcat-native-1.2.26-src.tar.gz"
  mirror "https://archive.apache.org/dist/tomcat/tomcat-connectors/native/1.2.26/source/tomcat-native-1.2.26-src.tar.gz"
  sha256 "b7e5449d206803d6581e0bda7694c9ca8b989938e0054c468df87f9ecb28757d"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "3b0f75610b602e3708086306a3e1d0bbe999733d31781528c9046c438466f1df" => :big_sur
    sha256 "2ee50a4c91f3aa4730f5c377c4ef7c9a9494b3e02e6749412bb75e1708ad31b3" => :arm64_big_sur
    sha256 "cbf3a72459605532c35448ef1b6cf29096c727ee351e21da920f0f3b60f35da6" => :catalina
    sha256 "69416e41dfcad81232fb36a103e3e62c57f8f4a1418ebbf5e083c17fba5b5f9b" => :mojave
  end

  depends_on "libtool" => :build
  depends_on "apr"
  depends_on "openjdk"
  depends_on "openssl@1.1"
  depends_on "tomcat"

  def install
    cd "native" do
      system "./configure", "--prefix=#{prefix}",
                            "--with-apr=#{Formula["apr"].opt_prefix}",
                            "--with-java-home=#{Formula["openjdk"].opt_prefix}",
                            "--with-ssl=#{Formula["openssl@1.1"].opt_prefix}"

      # fixes occasional compiling issue: glibtool: compile: specify a tag with `--tag'
      args = ["LIBTOOL=glibtool --tag=CC"]
      # fixes a broken link in mountain lion's apr-1-config (it should be /XcodeDefault.xctoolchain/):
      # usr/local/opt/libtool/bin/glibtool: line 1125:
      # /Applications/Xcode.app/Contents/Developer/Toolchains/OSX10.8.xctoolchain/usr/bin/cc:
      # No such file or directory
      args << "CC=#{ENV.cc}"
      system "make", *args
      system "make", "install"
    end
  end

  def caveats
    <<~EOS
      In order for tomcat's APR lifecycle listener to find this library, you'll
      need to add it to java.library.path. This can be done by adding this line
      to $CATALINA_HOME/bin/setenv.sh

        CATALINA_OPTS=\"$CATALINA_OPTS -Djava.library.path=#{opt_lib}\"

      If $CATALINA_HOME/bin/setenv.sh doesn't exist, create it and make it executable.
    EOS
  end
end
