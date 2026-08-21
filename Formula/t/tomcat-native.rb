class TomcatNative < Formula
  desc "Lets Tomcat use some native resources for performance"
  homepage "https://tomcat.apache.org/native-doc/"
  url "https://www.apache.org/dyn/closer.lua?path=tomcat/tomcat-connectors/native/2.0.15/source/tomcat-native-2.0.15-src.tar.gz"
  mirror "https://archive.apache.org/dist/tomcat/tomcat-connectors/native/2.0.15/source/tomcat-native-2.0.15-src.tar.gz"
  sha256 "8dab09f21ad519c9e49e5287f8d8de89bb176a5e3968479f27948c31b2a3b6b4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c2103b257bc7f7a4a91ca0c7a7eee3557730e5a93eadb6cd3f9cd625e4f94542"
    sha256 cellar: :any, arm64_sequoia: "6f5e64731697e06298090762503396bd7049ff06bdd34d53f6878addc4c13216"
    sha256 cellar: :any, arm64_sonoma:  "20a82bd074d89a7e20a700b7c02ecd8f06b5883f4c8e58809b4c92369bf71b09"
    sha256 cellar: :any, sonoma:        "b0c80c77a3facb80378c59833e6c8b43934a47ac4c883f0b77e70f11297dd844"
    sha256 cellar: :any, arm64_linux:   "5be3ad52f02ae557231d0c3f9a73ae5e312a9654e3b193319d6a86e7de4769b3"
    sha256 cellar: :any, x86_64_linux:  "4699481877c6c81ddf9d8793304ca826ac845cf964708a2a9884973954958009"
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
