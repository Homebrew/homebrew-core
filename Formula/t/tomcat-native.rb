class TomcatNative < Formula
  desc "Lets Tomcat use some native resources for performance"
  homepage "https://tomcat.apache.org/native-doc/"
  url "https://www.apache.org/dyn/closer.lua?path=tomcat/tomcat-connectors/native/2.0.16/source/tomcat-native-2.0.16-src.tar.gz"
  mirror "https://archive.apache.org/dist/tomcat/tomcat-connectors/native/2.0.16/source/tomcat-native-2.0.16-src.tar.gz"
  sha256 "785fdd99a202f442b085bc718d2fbeb393b85979aa4a2943302118c4acd68630"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "30ff0dbd36edab0d78af20da688004b2ee9e13980f276f69037bd95ec04a56ab"
    sha256 cellar: :any, arm64_tahoe:       "8d04e331907d5ec97d93580b3b7652ca30b00933f9606258efac527f939879a4"
    sha256 cellar: :any, arm64_sequoia:     "dc1a1c99a7a5b302c25d131ea5c5db1f5663f9ea0f09a16dc7361d22807029e2"
    sha256 cellar: :any, arm64_sonoma:      "aebdc5a10c167d482ec32aaeba11d8a21cb6b7eb81576254a5114a127ef9a70b"
    sha256 cellar: :any, arm64_linux:       "122404412691dfff4d0d847c3fbba8e761e6624544a4983bcea3c3a2f9edc075"
    sha256 cellar: :any, x86_64_linux:      "e432921e28e58ac086b67de5ee5ceb676355079d08acb51d090c51054b71191d"
  end

  depends_on "tomcat" => :test
  depends_on "apr"
  depends_on "openjdk"
  depends_on "openssl@3"

  def install
    cd "native" do
      system "./configure", "--with-apr=#{formula_opt_prefix("apr")}",
                            "--with-java-home=#{formula_opt_prefix("openjdk")}",
                            "--with-ssl=#{formula_opt_prefix("openssl@3")}",
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
