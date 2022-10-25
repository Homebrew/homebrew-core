class TomeeWebprofile < Formula
  desc "All-Apache Java EE 7 Web Profile stack"
  homepage "https://tomee.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomee/tomee-8.0.13/apache-tomee-8.0.13-webprofile.tar.gz"
  mirror "https://archive.apache.org/dist/tomee/tomee-8.0.13/apache-tomee-8.0.13-webprofile.tar.gz"
  sha256 "411ff6f25497c0886351e4bffbbf3bc61981d81b114688a4a4c5ae0bb5cfed9e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cf5cf820b5514895fae689b0e87dd477b3f671b5750017b2dbfd7e4686d309f6"
  end

  depends_on "openjdk"

  def install
    # Remove Windows scripts
    rm_rf Dir["bin/*.bat"]
    rm_rf Dir["bin/*.bat.original"]
    rm_rf Dir["bin/*.exe"]

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
