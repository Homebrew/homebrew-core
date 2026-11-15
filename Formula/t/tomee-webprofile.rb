class TomeeWebprofile < Formula
  desc "All-Apache Java EE 7 Web Profile stack"
  homepage "https://tomee.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomee/tomee-10.3.0/apache-tomee-10.3.0-webprofile.tar.gz"
  mirror "https://archive.apache.org/dist/tomee/tomee-10.3.0/apache-tomee-10.3.0-webprofile.tar.gz"
  sha256 "66735d3ae0c48deb41d44d2c8f3c6c475a929eed9bfc96eaf7b1c89ff8ddef43"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0d2995674cd8bfb16791039e145fe442832414d3870102d0c78fd640cc81f32b"
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
    ENV["JAVA_HOME"] = formula_opt_prefix("openjdk")
    system "#{opt_libexec}/bin/configtest.sh"
  end
end
