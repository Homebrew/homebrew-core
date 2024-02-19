class TomcatNative < Formula
  desc "Lets Tomcat use some native resources for performance"
  homepage "https://tomcat.apache.org/native-doc/"
  url "https://www.apache.org/dyn/closer.lua?path=tomcat/tomcat-connectors/native/2.0.7/source/tomcat-native-2.0.7-src.tar.gz"
  mirror "https://archive.apache.org/dist/tomcat/tomcat-connectors/native/2.0.7/source/tomcat-native-2.0.7-src.tar.gz"
  sha256 "2c5afc7edc383e47660647e9a7071ad81f58e51c7f765c12f7e7afc9203b2d4d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "014631e3a3859e6b89467595ffae29925f814adef848eb289e79ebc145f30bfb"
    sha256 cellar: :any,                 arm64_ventura:  "0b072a386026b4dd1a362cdd83dd70f3f737886b1a51d1b4342edc91939a386f"
    sha256 cellar: :any,                 arm64_monterey: "fa9f8fe15e392391367ab4a67083c64f19fefe1e99281f6f97685e4fa9a19caf"
    sha256 cellar: :any,                 sonoma:         "eb78e4d28bfc26dd1731222fbb922b01155d40bb53cbefae7e16fa2c9ae6b6a0"
    sha256 cellar: :any,                 ventura:        "18d564ee68a8d50ebf2c5fa31fa2705f305647abce4c53823e2e7277ba581182"
    sha256 cellar: :any,                 monterey:       "d82dd815d5a890ce16ffbc08e1e5436c21bd4bbbce2932552fdec018423c8df1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef36f1ac0fe69c2590025dd4b40492b0518b6048fdf9f88b4331d5615783eb46"
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
