class TomcatNative < Formula
  desc "Lets Tomcat use some native resources for performance"
  homepage "https://tomcat.apache.org/native-doc/"
  url "https://www.apache.org/dyn/closer.lua?path=tomcat/tomcat-connectors/native/2.0.1/source/tomcat-native-2.0.1-src.tar.gz"
  mirror "https://archive.apache.org/dist/tomcat/tomcat-connectors/native/2.0.1/source/tomcat-native-2.0.1-src.tar.gz"
  sha256 "184679dc9e8d704003e720b87db10750982ddffb21b13eedc30b5e666748d775"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7c54a353a041d368ccad8d5f100e6447c49bb147f8faa5d3b2746490bd76133a"
    sha256 cellar: :any,                 arm64_big_sur:  "8229fff2160636f13d15929eeadd36e5b95ad52cf2fdd9d46c9776e26f011671"
    sha256 cellar: :any,                 monterey:       "7d031077ada537c10af2ee0f3f9ab1f91120719f357a05e671d1dc861df9b4c5"
    sha256 cellar: :any,                 big_sur:        "ce38776754b389217ce2d83a3e103f1d236a76d6b421fb089ad781a323a31032"
    sha256 cellar: :any,                 catalina:       "43ead589f500bc5e469edf94abf87be7d61d8670e319ea3bb6e6c4a50aad5433"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db7d2363b27cabeec3520fffddac6c4600218dc803380b2114a15e8b8e5a84da"
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
