class TomcatNative < Formula
  desc "Lets Tomcat use some native resources for performance"
  homepage "https://tomcat.apache.org/native-doc/"
  url "https://www.apache.org/dyn/closer.lua?path=tomcat/tomcat-connectors/native/2.0.13/source/tomcat-native-2.0.13-src.tar.gz"
  mirror "https://archive.apache.org/dist/tomcat/tomcat-connectors/native/2.0.13/source/tomcat-native-2.0.13-src.tar.gz"
  sha256 "4f002c493c5020279acaa761a989964ba56954793a5c0718bc70969c8bb11dd5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9e94fa4a46572efb06b80bde5ab94b15ac2742d49442206f79ced7c01bed7c78"
    sha256 cellar: :any,                 arm64_sequoia: "1886a9e84f22c1795a1f1c7eaa4047a2927413b304696a116cf18c462375d81e"
    sha256 cellar: :any,                 arm64_sonoma:  "4479e8dda1aa064f86ad6ed61fb29e8f7e321d2d20bcdce300a71055a67eb44d"
    sha256 cellar: :any,                 sonoma:        "cebc2767d039638e0f7b1f8ec3bd28b024b0f07450466ed936b6b1a3a7568df8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81bd3868334e8814123286ef7b73159b727a83216a8f88a0f2b374a5c91aa227"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32c42a7aa7a685db886a626e2d9c1337d5f9690131d289315a87e38d8be87ab1"
  end

  depends_on "tomcat" => :test
  depends_on "apr"
  depends_on "openjdk"
  depends_on "openssl@3"

  def install
    cd "native" do
      system "./configure", "--with-apr=#{Formula["apr"].opt_prefix}",
                            "--with-java-home=#{Formula["openjdk"].opt_prefix}",
                            "--with-ssl=#{Formula["openssl@3"].opt_prefix}",
                            *std_configure_args
      system "make"
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

  test do
    ENV["CATALINA_BASE"] = testpath
    tomcat = Formula["tomcat"]
    cp_r tomcat.libexec.children, testpath
    (testpath/"bin/setenv.sh").write <<~SH
      CATALINA_OPTS="$CATALINA_OPTS -Djava.library.path=#{opt_lib}"
    SH
    chmod "+x", "bin/setenv.sh"

    pid = spawn(tomcat.bin/"catalina", "start")
    sleep 10
    sleep 10 if OS.mac? && Hardware::CPU.intel?
    begin
      system tomcat.bin/"catalina", "stop"
    ensure
      Process.wait pid
    end

    output = (testpath/"logs/catalina.out").read
    assert_match(/Loaded Apache Tomcat Native library .* using APR version/, output)
    assert_match "OpenSSL successfully initialized", output
  end
end
