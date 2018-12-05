class TomcatNative < Formula
  desc "Lets Tomcat use some native resources for performance"
  homepage "https://tomcat.apache.org/native-doc/"
  url "https://www.apache.org/dyn/closer.cgi?path=tomcat/tomcat-connectors/native/1.2.18/source/tomcat-native-1.2.18-src.tar.gz"
  sha256 "846c579ff81655f72382597272c1bcf850491d39ba5ba079b541c79887d827d2"

  bottle do
    cellar :any
    sha256 "91d644803c75d85a149c17ef213e80b7c81e867f7e226e70bc346ffc731a70bc" => :mojave
    sha256 "137532c6913d0cde5b0bd4ef6ce317cbc276774e2bebfea7deb56f9b851fcc8b" => :high_sierra
    sha256 "87df7d63fe779e9a703064a5257278f36ff125564a450862406cf27837f19d69" => :sierra
    sha256 "a6d4ba16ee959ddfd2c5b0430d3e812898893bd5b6fbc54828a5d84544e4fa1b" => :el_capitan
  end

  depends_on "libtool" => :build
  depends_on "apr"
  depends_on :java => "1.7+"
  depends_on "openssl"
  depends_on "tomcat" => :recommended

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

  def caveats; <<~EOS
    In order for tomcat's APR lifecycle listener to find this library, you'll
    need to add it to java.library.path. This can be done by adding this line
    to $CATALINA_HOME/bin/setenv.sh

      CATALINA_OPTS=\"$CATALINA_OPTS -Djava.library.path=#{opt_lib}\"

    If $CATALINA_HOME/bin/setenv.sh doesn't exist, create it and make it executable.
  EOS
  end
end
