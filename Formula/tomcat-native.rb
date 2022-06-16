class TomcatNative < Formula
  desc "Lets Tomcat use some native resources for performance"
  homepage "https://tomcat.apache.org/native-doc/"
  url "https://www.apache.org/dyn/closer.lua?path=tomcat/tomcat-connectors/native/1.2.34/source/tomcat-native-1.2.34-src.tar.gz"
  mirror "https://archive.apache.org/dist/tomcat/tomcat-connectors/native/1.2.34/source/tomcat-native-1.2.34-src.tar.gz"
  sha256 "b7571881f527c079b4e9114f556797d11ce483db28f55f9a5943fc0eea82d930"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "afba44a13503c085aa4c2bc04ae214ea3e308e8efeb8ddbf28fbea74d910f3ae"
    sha256 cellar: :any,                 arm64_big_sur:  "cf4ad6e34bd693103a4215fbf07880b101c7d82dd134e1e88665518a226a5488"
    sha256 cellar: :any,                 monterey:       "bf7f822a871f9235e68b2992214b68dc46070de10928c1087aca297b8ad0697a"
    sha256 cellar: :any,                 big_sur:        "ec404eb9a6ddeb729105ecaa53b74372450e4b63dd2091cd56d49cd0ff6d2310"
    sha256 cellar: :any,                 catalina:       "0f8b40945e5b939b7e97f97696f7a846ac9d353033ad8159db63b6bff5846340"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c1167d8baacd91f44e1a62cbc6581f2eb06b4d6ef363e3a289224611f830e8b"
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
