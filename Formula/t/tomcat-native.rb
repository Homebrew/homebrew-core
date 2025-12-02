class TomcatNative < Formula
  desc "Lets Tomcat use some native resources for performance"
  homepage "https://tomcat.apache.org/native-doc/"
  url "https://www.apache.org/dyn/closer.lua?path=tomcat/tomcat-connectors/native/2.0.9/source/tomcat-native-2.0.9-src.tar.gz"
  mirror "https://archive.apache.org/dist/tomcat/tomcat-connectors/native/2.0.9/source/tomcat-native-2.0.9-src.tar.gz"
  sha256 "8aed0def414d7f49b688e826797513e95182ecbd7b6f8b6f025e527b85065c02"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0f826440c6ed78de39219996ddfa952959ad65b1361b478ab48e0430dc3c041c"
    sha256 cellar: :any,                 arm64_sequoia: "d69d5e50666db22767640427773e7f032e40bb9a4802fc48f0a1b7991263fe4b"
    sha256 cellar: :any,                 arm64_sonoma:  "54bac94b6a98b710c507941c7a6c750256f001c86a0605f828b176b53a4d5773"
    sha256 cellar: :any,                 arm64_ventura: "82f712cd4cc80f9a85c240fe8eefacf0de8f2c8191020533d20575dee8bbb1b8"
    sha256 cellar: :any,                 sonoma:        "670968ff66ddab50702616d827e2c15cdbb97a95def107c0707224f3feaa6b49"
    sha256 cellar: :any,                 ventura:       "0c1abba080581dfadb7557e36ff283c7dff8655eef0aaaba5807fc58015c9405"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b34d0fa510a7c5365e1d983d3046a89bf03223247e3e7676158652f002bc175"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66f6cf0d5dcb235699a3c4606eef141556286eefc51c574b643fd53acc1f2d1e"
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
