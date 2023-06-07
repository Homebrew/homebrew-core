class TomcatNative < Formula
  desc "Lets Tomcat use some native resources for performance"
  homepage "https://tomcat.apache.org/native-doc/"
  url "https://www.apache.org/dyn/closer.lua?path=tomcat/tomcat-connectors/native/2.0.4/source/tomcat-native-2.0.4-src.tar.gz"
  mirror "https://archive.apache.org/dist/tomcat/tomcat-connectors/native/2.0.4/source/tomcat-native-2.0.4-src.tar.gz"
  sha256 "32ec9847c8c841d330797b65deb71cb7d98b26f556fdd0079a8dbf0306b857f2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cd6bd5d0ef6519372af433d7d95ddc89d8bab7da9b0a1c538fc79e17b03f82de"
    sha256 cellar: :any,                 arm64_monterey: "9842e1f434a5226d6d3054dc26d33c42a348d7cd62316ba0daf5e01d0e880795"
    sha256 cellar: :any,                 arm64_big_sur:  "15c10ec76ed7f6fd29dd8844615a900c7b8da98d90a4839da7e6f8b12f5742ab"
    sha256 cellar: :any,                 ventura:        "a3e073d92a5c735e0953f6e49860e3551f2fb4338b0af59f73c7952ecd1005d7"
    sha256 cellar: :any,                 monterey:       "0c7c21432ab93f3c5996774bca69854500b151742261833daf7bda707fc03588"
    sha256 cellar: :any,                 big_sur:        "b149f9ef73faaea2c77ed17aa9d24f5d2f4ec85da28eb2b271a7943bfaa3e02f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "454f1e77277c9aa83f34fa15a532ac65a2e4f72a67ab272be867c6ce922ee938"
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
