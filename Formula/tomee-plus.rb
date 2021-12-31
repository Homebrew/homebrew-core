class TomeePlus < Formula
  desc "Everything in TomEE Web Profile and JAX-RS, plus more"
  homepage "https://tomee.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomee/tomee-8.0.8/apache-tomee-8.0.8-plus.tar.gz"
  mirror "https://archive.apache.org/dist/tomee/tomee-8.0.8/apache-tomee-8.0.8-plus.tar.gz"
  sha256 "215afbb47532a6d96e3e18d686952a2524984326601f6b23d35ee66b401a43e5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "22caa716db782e1fee20c043d26642c3e4654a9562fca2bdda0f7440a260b34b"
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
    (bin/"tomee-plus-startup").write_env_script "#{libexec}/bin/startup.sh",
                                                Language::Java.overridable_java_home_env
  end

  def caveats
    <<~EOS
      The home of Apache TomEE Plus is:
        #{opt_libexec}
      To run Apache TomEE:
        #{opt_libexec}/bin/tomee-plus-startup
    EOS
  end

  test do
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix
    system "#{opt_libexec}/bin/configtest.sh"
  end
end
