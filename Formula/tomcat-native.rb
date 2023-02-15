class TomcatNative < Formula
  desc "Lets Tomcat use some native resources for performance"
  homepage "https://tomcat.apache.org/native-doc/"
  url "https://www.apache.org/dyn/closer.lua?path=tomcat/tomcat-connectors/native/2.0.3/source/tomcat-native-2.0.3-src.tar.gz"
  mirror "https://archive.apache.org/dist/tomcat/tomcat-connectors/native/2.0.3/source/tomcat-native-2.0.3-src.tar.gz"
  sha256 "63b2ae98a9077033a2da3f01afc0accb835f227d51a971e2b5be23d1b9333c5e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3b633bc68019c22716eed103c3236de4be793fa015ca518061ade6154859f39a"
    sha256 cellar: :any,                 arm64_monterey: "a7dd0b58fd9f211ab8423676e1ab67ea38d65e3f25435136cfeae98d2f92251a"
    sha256 cellar: :any,                 arm64_big_sur:  "f9a0a5cb92dd829097631bc1ce34a9a6fcc8e3162bc692224c96556235c9db79"
    sha256 cellar: :any,                 ventura:        "d3ebf26458ba5f3f38cac50d04b13ae063b29ca84bcf641f1d6666a121d4e474"
    sha256 cellar: :any,                 monterey:       "c93f19e6971b2abb030baa3164c68ee51b44f71a340a69781acc4a8bad136ed3"
    sha256 cellar: :any,                 big_sur:        "66875607b4a4e0aacff1e7c11fe0a2fcc0cedbfed29a8148364dabae13a0cdd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec2313607fc41e59e37409dbe266c14cb7b1546fdbeec10ab6195ea3a43c1591"
  end

  depends_on "libtool" => :build
  depends_on "apr"
  depends_on "openjdk"
  depends_on "openssl@3"

  def install
    cd "native" do
      system "./configure", "--prefix=#{prefix}",
                            "--with-apr=#{Formula["apr"].opt_prefix}",
                            "--with-java-home=#{Formula["openjdk"].opt_prefix}",
                            "--with-ssl=#{Formula["openssl@3"].opt_prefix}"

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

        CATALINA_OPTS="$CATALINA_OPTS -Djava.library.path=#{opt_lib}"

      If $CATALINA_HOME/bin/setenv.sh doesn't exist, create it and make it executable.
    EOS
  end
end
