class TomcatNative < Formula
  desc "Lets Tomcat use some native resources for performance"
  homepage "https://tomcat.apache.org/native-doc/"
  url "https://www.apache.org/dyn/closer.lua?path=tomcat/tomcat-connectors/native/1.2.27/source/tomcat-native-1.2.27-src.tar.gz"
  mirror "https://archive.apache.org/dist/tomcat/tomcat-connectors/native/1.2.27/source/tomcat-native-1.2.27-src.tar.gz"
  sha256 "a7913f01f657eb855326585328f2dbc0aea3417f4ceb15714f7b86759b904c0f"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_big_sur: "83d385a2885597cc4328bc4b02606a2ef71f6c9e1eaf6fd86447ded9434fd35f"
    sha256 cellar: :any, big_sur:       "f68701192abcedd4183a493866942b8d7b8d7783001f99446448600bcf723f0b"
    sha256 cellar: :any, catalina:      "6d12407e932d68bb1fc9321c49b1cd295280d7067a6025c69c6f750d02b6b6b3"
    sha256 cellar: :any, mojave:        "9fd979f6bd97002997af9d877a4727a36ec2b160fe0e852c2f035409dc2494e0"
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
