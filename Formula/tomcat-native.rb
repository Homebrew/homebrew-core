class TomcatNative < Formula
  desc "Lets Tomcat use some native resources for performance"
  homepage "https://tomcat.apache.org/native-doc/"
  url "https://www.apache.org/dyn/closer.lua?path=tomcat/tomcat-connectors/native/1.2.28/source/tomcat-native-1.2.28-src.tar.gz"
  mirror "https://archive.apache.org/dist/tomcat/tomcat-connectors/native/1.2.28/source/tomcat-native-1.2.28-src.tar.gz"
  sha256 "6001129bbefa40ba92268d722c8c101e3c5c9fd969534799f682bb0e0bce6c6a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "d5b0732197c5cb2725a782c00ade437b56437902877a1ee9a9243aa082837872"
    sha256 cellar: :any, big_sur:       "b7927a1b378281e8c318d19cc6cadeb3abedd39b1d2dce0b021ca54082bd714f"
    sha256 cellar: :any, catalina:      "7ca15193dda017ea444ca92da0a7789844731cd3d4594970e84c5a399daccac6"
    sha256 cellar: :any, mojave:        "4530aff033f5dc75a273f0f09bc0b70aa83949b9caa741288068f99ccbe47828"
  end

  depends_on "libtool" => :build
  depends_on "apr"
  depends_on "openjdk"
  depends_on "openssl@1.1"

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
