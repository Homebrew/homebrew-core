class TomcatNative < Formula
  desc "Lets Tomcat use some native resources for performance"
  homepage "https://tomcat.apache.org/native-doc/"
  url "https://www.apache.org/dyn/closer.lua?path=tomcat/tomcat-connectors/native/1.2.32/source/tomcat-native-1.2.32-src.tar.gz"
  mirror "https://archive.apache.org/dist/tomcat/tomcat-connectors/native/1.2.32/source/tomcat-native-1.2.32-src.tar.gz"
  sha256 "805ca999267f07afe701a8a434d517dc0b7f4317c366560f43c0fbca593578bd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0db604ba8ddb54aee98fd24a6dd429d6a329e43c48db4304718bfb0e279895d4"
    sha256 cellar: :any,                 arm64_big_sur:  "d7b2dad97f753b4aff411742464680db833ef41af0c7f72d5eed3af8fda88c4a"
    sha256 cellar: :any,                 monterey:       "dec7b9b3548b1219ca40ef6b3de6fdb6d86b40f90dbc591cce5f81500bb0cfd3"
    sha256 cellar: :any,                 big_sur:        "e448323560b59e7dba38eced437f40e97d16b8cb22928eb2516f375726cb833b"
    sha256 cellar: :any,                 catalina:       "24d1d3240e4d75d46db1ee1272da32eb86fed9df138b7006242950b85f0faca6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50f3b5c9a2405cbbc89dfae6ab20d792e9eb48a2eb3cc0939a7db0d75ce1fc9b"
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
