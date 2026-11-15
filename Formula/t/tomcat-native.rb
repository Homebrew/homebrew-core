class TomcatNative < Formula
  desc "Lets Tomcat use some native resources for performance"
  homepage "https://tomcat.apache.org/native-doc/"
  url "https://www.apache.org/dyn/closer.lua?path=tomcat/tomcat-connectors/native/2.0.17/source/tomcat-native-2.0.17-src.tar.gz"
  mirror "https://archive.apache.org/dist/tomcat/tomcat-connectors/native/2.0.17/source/tomcat-native-2.0.17-src.tar.gz"
  sha256 "35a8aee8ab2ccce587dfea5ea3c78847f72f733fec4184ab7521d0d3a34d29a5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "dc934497c32239fc13dfbeb08f58ff47b828497b804cebb55bde114c204fabda"
    sha256 cellar: :any, arm64_tahoe:       "1b63900a41828bd4573a306ea94729905316f9e3a9e84237b4d2189a01c78a4e"
    sha256 cellar: :any, arm64_sequoia:     "9dd8a053bd1885ea76fbbb815e9a42664c3b3893b470f892bcd7c2e823a46187"
    sha256 cellar: :any, arm64_linux:       "a525ca2b758e4f29d6a686fa98c58d89cb9f1f12f600af4e2d2a949631e4cac3"
    sha256 cellar: :any, x86_64_linux:      "7e661e20ebe71d0047a6e2927a1c3a143a94b756614a3ba877ac84d04b413d31"
  end

  depends_on "tomcat" => :test
  depends_on "apr"
  depends_on "openjdk"
  depends_on "openssl@4"

  allow_network_access! :test

  def install
    cd "native" do
      system "./configure", "--with-apr=#{formula_opt_prefix("apr")}",
                            "--with-java-home=#{formula_opt_prefix("openjdk")}",
                            "--with-ssl=#{formula_opt_prefix("openssl@4")}",
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
