class TomcatNative < Formula
  desc "Lets Tomcat use some native resources for performance"
  homepage "https://tomcat.apache.org/native-doc/"
  url "https://www.apache.org/dyn/closer.lua?path=tomcat/tomcat-connectors/native/1.2.31/source/tomcat-native-1.2.31-src.tar.gz"
  mirror "https://archive.apache.org/dist/tomcat/tomcat-connectors/native/1.2.31/source/tomcat-native-1.2.31-src.tar.gz"
  sha256 "acc0e6e342fbdda54b029564405322823c93d83f9d64363737c1cbcc3af1c1fd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "c1871b1b96ce328260184458fa598eb6664a4afdef2e92f8de6dc2574f2f077e"
    sha256 cellar: :any,                 big_sur:       "8c740bb2aed61249b111b7d40e0c09988c5c5b717ae3af5724f3fbcc616c3dee"
    sha256 cellar: :any,                 catalina:      "8f840854bbab495964cd8e49f47f38db7f8aae94ede0c80cdfa64bf45cbd3610"
    sha256 cellar: :any,                 mojave:        "f4912c4d778256a7104b20ff7d767fb12c2c78db7d321e1e8e7e7f301473d903"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b9c54d40c405527d1540122cea43b9d01d550151625b74bdc7c2df5ace6c8db"
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
