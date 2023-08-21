class TomcatNative < Formula
  desc "Lets Tomcat use some native resources for performance"
  homepage "https://tomcat.apache.org/native-doc/"
  url "https://www.apache.org/dyn/closer.lua?path=tomcat/tomcat-connectors/native/2.0.5/source/tomcat-native-2.0.5-src.tar.gz"
  mirror "https://archive.apache.org/dist/tomcat/tomcat-connectors/native/2.0.5/source/tomcat-native-2.0.5-src.tar.gz"
  sha256 "958d1f121651c10c61556d77dc9d0d41f3b53988a2195442de4ac6f4cb878388"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "757fa3646a2c6122cd7097585a894da8b3144041230af9c7074759b36eacb918"
    sha256 cellar: :any,                 arm64_monterey: "cc1b46de9303938ac5503b834b8f09139b3cdd7ebb6dcfd18127c83e4f812b2a"
    sha256 cellar: :any,                 arm64_big_sur:  "5e4a72e6a7db883c035565c0d8e25387b47d73523b9dbec9facdd3e86ce743db"
    sha256 cellar: :any,                 ventura:        "e7bb2186964976ec00a5573b7e4b921ae543fef8887c48c95c8d4cf8fb2c57c6"
    sha256 cellar: :any,                 monterey:       "804d8417b7280526f62cc392d7ef68512da428c3aed2402c188f35b9001ece1b"
    sha256 cellar: :any,                 big_sur:        "f2a5324db3c1fa91c60d45edf4f1f057f02f6eb2d885d1b459badc38fc9a881b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f2ce338e79d3fed7b40061f8ffae4d73d96196853a211bfa8be165fccccede6"
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
