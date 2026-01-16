class TomcatNative < Formula
  desc "Lets Tomcat use some native resources for performance"
  homepage "https://tomcat.apache.org/native-doc/"
  url "https://www.apache.org/dyn/closer.lua?path=tomcat/tomcat-connectors/native/2.0.12/source/tomcat-native-2.0.12-src.tar.gz"
  mirror "https://archive.apache.org/dist/tomcat/tomcat-connectors/native/2.0.12/source/tomcat-native-2.0.12-src.tar.gz"
  sha256 "8894d0f1577e78342585a706050b7ff4b557ff385cdcea0424404c593bfd3104"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4e01dd36b8ffb4142022b2eb0116bf18f8fb585ee692fdccc703424d1152aa24"
    sha256 cellar: :any,                 arm64_sequoia: "41127b5c7120f5f50ac6756d6f493774196d194a0ee1c5f466177b57859aa512"
    sha256 cellar: :any,                 arm64_sonoma:  "d9c73e99175795a8e990a0c3f62169d88d9c3c1b0464b509c79b8a4e3b4e8f4e"
    sha256 cellar: :any,                 sonoma:        "a086b92c91f2b3102286a15f19d084575d4a121e889435f43b60f34bcaad65ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "878e73479b33b55d77ce631ef552fa07e8c3fd41a7676aad68781b68908eddb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f83af9454f911923129a311af634d014c19f1493bc121b0ca18d5e522ba7bfa0"
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
