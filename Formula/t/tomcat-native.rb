class TomcatNative < Formula
  desc "Lets Tomcat use some native resources for performance"
  homepage "https://tomcat.apache.org/native-doc/"
  url "https://www.apache.org/dyn/closer.lua?path=tomcat/tomcat-connectors/native/2.0.14/source/tomcat-native-2.0.14-src.tar.gz"
  mirror "https://archive.apache.org/dist/tomcat/tomcat-connectors/native/2.0.14/source/tomcat-native-2.0.14-src.tar.gz"
  sha256 "51ca50295c8005e6bb4a32a0cdc7ee5bc224406ae402075b031f5b3073bf2bdb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "01b772187233970deb6369572b96780df249dd649ee0df8d0ea377021040a1ff"
    sha256 cellar: :any,                 arm64_sequoia: "a19f2aef3544afb5d41638df10732d2ddef713f56c9316d5a47106245a88ead6"
    sha256 cellar: :any,                 arm64_sonoma:  "465c5a3b5ce554658afff8150d7a4094ed1beb812f4b3a3c3455bb5ee389e97a"
    sha256 cellar: :any,                 sonoma:        "d2074e2e3e88c13c3f4654f7a486a35008d2f2f39ad7b382e7e191553c67abbd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4cd5f44f63aeb7529c886a3962daccae4b9648d5f78066f613690e07de96524e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a859cb4a87a10540f1f6ad44cbb043595d36c5049667be1097a2be24af8a54b"
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
