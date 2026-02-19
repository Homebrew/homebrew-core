class TomeeWebprofile < Formula
  desc "All-Apache Java EE 7 Web Profile stack"
  homepage "https://tomee.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomee/tomee-10.1.4/apache-tomee-10.1.4-webprofile.tar.gz"
  mirror "https://archive.apache.org/dist/tomee/tomee-10.1.4/apache-tomee-10.1.4-webprofile.tar.gz"
  sha256 "388b1e351ab92e50c1100bbdc1a208352359111a994b40b837300f44ca95b389"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8f63dd87a921a725e0aabddd6b8fe36af6865b1a3ff4bdf23e779c28c79ba612"
  end

  depends_on "openjdk"

  def install
    # Remove Windows scripts
    rm_r(Dir["bin/*.bat"])
    rm_r(Dir["bin/*.bat.original"])
    rm_r(Dir["bin/*.exe"])

    # Install files
    prefix.install %w[NOTICE LICENSE RELEASE-NOTES RUNNING.txt]
    libexec.install Dir["*"]
    (bin/"tomee-webprofile-startup").write_env_script "#{libexec}/bin/startup.sh",
                                                      Language::Java.overridable_java_home_env
  end

  def caveats
    <<~EOS
      The home of Apache TomEE Web is:
        #{opt_libexec}
      To run Apache TomEE:
        #{opt_libexec}/bin/tomee-webprofile-startup
    EOS
  end

  test do
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix
    system "#{opt_libexec}/bin/configtest.sh"
  end
end
