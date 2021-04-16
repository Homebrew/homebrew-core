class TomcatNative < Formula
  desc "Lets Tomcat use some native resources for performance"
  homepage "https://tomcat.apache.org/native-doc/"
  url "https://www.apache.org/dyn/closer.lua?path=tomcat/tomcat-connectors/native/1.2.28/source/tomcat-native-1.2.28-src.tar.gz"
  mirror "https://archive.apache.org/dist/tomcat/tomcat-connectors/native/1.2.28/source/tomcat-native-1.2.28-src.tar.gz"
  sha256 "6001129bbefa40ba92268d722c8c101e3c5c9fd969534799f682bb0e0bce6c6a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "74e7fc2f2daf20e093d04b2824e54f8ec18c232f4a35022f02a01a4773ffdda1"
    sha256 cellar: :any, big_sur:       "48199e2a009ef4af86fe6baadb096c8e58f260aceb1cdd133cfafe23b611fd41"
    sha256 cellar: :any, catalina:      "1c8a86437238fb62588115a1c2488b73285256fc599005344226b63d257e2342"
    sha256 cellar: :any, mojave:        "fd3c098336a8cd6205c7239aa93215f3fc35c2ef6e1993b37e80911484a90dfc"
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
