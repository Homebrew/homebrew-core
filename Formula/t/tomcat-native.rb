class TomcatNative < Formula
  desc "Lets Tomcat use some native resources for performance"
  homepage "https://tomcat.apache.org/native-doc/"
  url "https://www.apache.org/dyn/closer.lua?path=tomcat/tomcat-connectors/native/2.0.6/source/tomcat-native-2.0.6-src.tar.gz"
  mirror "https://archive.apache.org/dist/tomcat/tomcat-connectors/native/2.0.6/source/tomcat-native-2.0.6-src.tar.gz"
  sha256 "be617c576e923b6079d0b75206d706da27dd043cebf50bfb95e3a9c0aa1d1a35"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9507f18e9d01cd379892eb8bf2d42cef8aedb0c6232276685536859825840cdb"
    sha256 cellar: :any,                 arm64_ventura:  "1ec24815be74d4ef939b85f78981e8b3341ca2afe376cfb79ec4b747502b6b5d"
    sha256 cellar: :any,                 arm64_monterey: "ddc403f23b57ac2d80969f52276506a025fe74ec6dcd1bd4f29968d6a26d6eae"
    sha256 cellar: :any,                 sonoma:         "9f80b5be3d2042eca8622c9b664a02032ed25c73893d9daf9c43232fe4c427f8"
    sha256 cellar: :any,                 ventura:        "1b9cb4c1eb2a3f1e2f9b7ceff1dd325db7f7d01e652ffb995936d713171f101e"
    sha256 cellar: :any,                 monterey:       "f7a06a06ad37a7039c9cc5cfef063aa685e1c1c877e73ffcdaee7c6be89ac769"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd7e0ec37cd09884e64e427916dd00725ae6f85e7d88419442683461682bd14a"
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
