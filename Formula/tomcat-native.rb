class TomcatNative < Formula
  desc "Lets Tomcat use some native resources for performance"
  homepage "https://tomcat.apache.org/native-doc/"
  url "https://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-connectors/native/1.2.12/source/tomcat-native-1.2.12-src.tar.gz"
  mirror "https://archive.apache.org/dist/tomcat/tomcat-connectors/native/1.2.12/source/tomcat-native-1.2.12-src.tar.gz"
  sha256 "e7add177c98a7f07220c306d65e182c45dbcd7501115e9ed56f1690c5472ded9"

  bottle do
    cellar :any
    sha256 "f70f31c3406a7b9e420869d4d6003fb967b85c2ea1a976a9738be35143ed4038" => :sierra
    sha256 "e1ebaa1c597c315e1426f4e540445eb1404681e130fab1fd2195173753278fa7" => :el_capitan
    sha256 "308e4924da12adefa37dfcd599330111c3571d6f3203bcfe77c3139a7a6d7458" => :yosemite
  end

  depends_on "libtool" => :build
  depends_on "tomcat" => :recommended
  depends_on :java => "1.7+"
  depends_on "openssl"
  depends_on "apr"

  def install
    cd "native" do
      system "./configure", "--prefix=#{prefix}",
                            "--with-apr=#{Formula["apr"].opt_prefix}",
                            "--with-java-home=#{ENV["JAVA_HOME"]}",
                            "--with-ssl=#{Formula["openssl"].opt_prefix}"

      # fixes occasional compiling issue: glibtool: compile: specify a tag with `--tag'
      args = ["LIBTOOL=glibtool --tag=CC"]
      # fixes a broken link in mountain lion's apr-1-config (it should be /XcodeDefault.xctoolchain/):
      # usr/local/opt/libtool/bin/glibtool: line 1125: /Applications/Xcode.app/Contents/Developer/Toolchains/OSX10.8.xctoolchain/usr/bin/cc: No such file or directory
      args << "CC=#{ENV.cc}" if MacOS.version >= :mountain_lion
      system "make", *args
      system "make", "install"
    end
  end

  def caveats; <<-EOS.undent
    In order for tomcat's APR lifecycle listener to find this library, you'll
    need to add it to java.library.path. This can be done by adding this line
    to $CATALINA_HOME/bin/setenv.sh

      CATALINA_OPTS=\"$CATALINA_OPTS -Djava.library.path=#{lib}\"

    If $CATALINA_HOME/bin/setenv.sh doesn't exist, create it and make it executable.
    EOS
  end
end
