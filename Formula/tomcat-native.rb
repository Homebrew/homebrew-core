class TomcatNative < Formula
  desc "Lets Tomcat use some native resources for performance"
  homepage "https://tomcat.apache.org/native-doc/"
  url "https://www.apache.org/dyn/closer.lua?path=tomcat/tomcat-connectors/native/1.2.32/source/tomcat-native-1.2.32-src.tar.gz"
  mirror "https://archive.apache.org/dist/tomcat/tomcat-connectors/native/1.2.32/source/tomcat-native-1.2.32-src.tar.gz"
  sha256 "805ca999267f07afe701a8a434d517dc0b7f4317c366560f43c0fbca593578bd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "94de42ed8da515cb63be2b5bab2322975f02810f214c575fb5a48f0f8df00900"
    sha256 cellar: :any,                 arm64_big_sur:  "c6f4dd11e7fbf16ad6f7e11b7d4c81e1ee6159bc025e0464430d920588fd1f24"
    sha256 cellar: :any,                 monterey:       "966d83820a8738edb2fea2fb2c4dbc4b18c786b70ddbed1c01126821a24e9241"
    sha256 cellar: :any,                 big_sur:        "41a3d1bd142f9af9709a09ef08fa9c1d4afba8c1df9afcf206680abef9cdc561"
    sha256 cellar: :any,                 catalina:       "49cb291540334f5a2b15ddbd2b597df9993cd958aa55d301b45b36389178c10e"
    sha256 cellar: :any,                 mojave:         "24a026ac8fbbaf58b678c8cb8b8eaaf6d1ffca5774fd761943bc49b1e1179366"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "330a4f42782065c9160ff41e5c55d483f1d866b569854db3b91f45959f553f1b"
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
