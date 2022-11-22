class TomcatNative < Formula
  desc "Lets Tomcat use some native resources for performance"
  homepage "https://tomcat.apache.org/native-doc/"
  url "https://www.apache.org/dyn/closer.lua?path=tomcat/tomcat-connectors/native/2.0.2/source/tomcat-native-2.0.2-src.tar.gz"
  mirror "https://archive.apache.org/dist/tomcat/tomcat-connectors/native/2.0.2/source/tomcat-native-2.0.2-src.tar.gz"
  sha256 "fd43aece5bf1b05a25efce932fa3fe6a2cfff5c6761469e992ab14d79180390d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "36ef0309b33e0d8e23c2d14ade8079b639ae8590e227e6a07c70e93b6cb6329a"
    sha256 cellar: :any,                 arm64_monterey: "ba2c9742c77ae897711ec828a0202e69a8f9e6a1bf1c7277d4f18d32f9dfdee0"
    sha256 cellar: :any,                 arm64_big_sur:  "18cc054f03000b2a518ba56c8ffb5ddb3a2418df69650b794f79afdeed29a756"
    sha256 cellar: :any,                 ventura:        "38c6f059e2aa83791ecd19792f5a0c3e08e365f0e271ddd799a92dd6c702f29b"
    sha256 cellar: :any,                 monterey:       "6bc8ea36d451aaf12a5262653df9a6b64dc4215f096ee27bac3267a311f820f0"
    sha256 cellar: :any,                 big_sur:        "5ac2468afb75cc641e96224c0f303eccc21967bf4516845a01aa658ef135383d"
    sha256 cellar: :any,                 catalina:       "5b3e559840c240f2d321006079f6493ba91ded605cdc5085813435a89d41504b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f29334e86606669244e9161e6c275f126e9570c5d4e722d363a0c7c9fc599f9"
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

        CATALINA_OPTS=\"$CATALINA_OPTS -Djava.library.path=#{opt_lib}\"

      If $CATALINA_HOME/bin/setenv.sh doesn't exist, create it and make it executable.
    EOS
  end
end
