class TomcatNative < Formula
  desc "Lets Tomcat use some native resources for performance"
  homepage "https://tomcat.apache.org/native-doc/"
  url "https://www.apache.org/dyn/closer.lua?path=tomcat/tomcat-connectors/native/2.0.8/source/tomcat-native-2.0.8-src.tar.gz"
  mirror "https://archive.apache.org/dist/tomcat/tomcat-connectors/native/2.0.8/source/tomcat-native-2.0.8-src.tar.gz"
  sha256 "c7c5382fcb5a647a5ce6fed0b96721e94198fa2f5725cf5124f5b6511b05dfef"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "7caf42d03492c53d43083891f42f64647bc3fb5ac40317d1fe8c66400638ae02"
    sha256 cellar: :any,                 arm64_sonoma:   "6b3347d417585b401fbb9e1573eb3875c50d9b4b35ef2da335f8e4eafce14a31"
    sha256 cellar: :any,                 arm64_ventura:  "ec858f97d5549c229516c7e76309e7335b867458d837378054cacf6b0faa5fbe"
    sha256 cellar: :any,                 arm64_monterey: "d7094e23b954b6193486ea5de1f30373a66108004dc66f2b983e71ad649cd5d0"
    sha256 cellar: :any,                 sonoma:         "6266f592dccf65035414e175135551b9a9eeb5dbe8051533ff53e09550f78f1c"
    sha256 cellar: :any,                 ventura:        "cf77f977158497e7924c40f37448e4c3f9ca09e5dac9adf702db4a1c660e59c8"
    sha256 cellar: :any,                 monterey:       "0032aae5e5ac4a08e503dc7ba1e95ccf6e88db975a50c898307fad8e7b86fb58"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "aaae8c9cf5b7d5b87b305a98773c73bc4ed6070d589ab1b79c04a1d50e4fe2aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b6871bc6de4e15f504981b8930ccd64e3b955ae2b73ec5642376f9dbf3d5efc"
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
