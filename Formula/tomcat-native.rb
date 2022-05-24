class TomcatNative < Formula
  desc "Lets Tomcat use some native resources for performance"
  homepage "https://tomcat.apache.org/native-doc/"
  url "https://www.apache.org/dyn/closer.lua?path=tomcat/tomcat-connectors/native/1.2.33/source/tomcat-native-1.2.33-src.tar.gz"
  mirror "https://archive.apache.org/dist/tomcat/tomcat-connectors/native/1.2.33/source/tomcat-native-1.2.33-src.tar.gz"
  sha256 "7540cff954774b3f8d8f7480f92f1c206a48f25440a62186b196c5930b45fea1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a88599a186bca25f582fe711f8dcafebadc8787eb1cf003ce000c7cbf3c37cf9"
    sha256 cellar: :any,                 arm64_big_sur:  "890682d04778956e82b03b820775463a95b7af370bac627849b048d465590945"
    sha256 cellar: :any,                 monterey:       "4f487558c8b9224652f58b4363b17f5945b9a3f63fc14bace56e13afff78ba32"
    sha256 cellar: :any,                 big_sur:        "605c8f340955713967e693d14ae9b139eb5668a860414ab6aa793e97888af26d"
    sha256 cellar: :any,                 catalina:       "844726d828179fe1752fd2f779aa862ac1419a4a45c3f53311de1eec2717d7ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dec7be5aa5ddb88434dd95734f91ba7791a0bed817ee4d81068667843373ce84"
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
