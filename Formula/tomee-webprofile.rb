class TomeeWebprofile < Formula
  desc "All-Apache Java EE 6 Web Profile stack"
  homepage "https://tomee.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=tomee/tomee-7.1.0/apache-tomee-7.1.0-webprofile.tar.gz"
  sha256 "ae15d81d960ea5ec875a6c8fd056458fa32bbd1ca87bbfa41e236d3cebbb9b49"

  bottle :unneeded

  depends_on :java => "1.8"

  def install
    # Remove Windows scripts
    rm_rf Dir["bin/*.bat"]
    rm_rf Dir["bin/*.bat.original"]
    rm_rf Dir["bin/*.exe"]

    # Install files
    prefix.install %w[NOTICE LICENSE RELEASE-NOTES RUNNING.txt]
    libexec.install Dir["*"]
    libexec.install_symlink "#{libexec}/bin/startup.sh" => "tomee-webprofile-startup"
    env = Language::Java.java_home_env("1.8")
    env[:JRE_HOME] = "$(#{Language::Java.java_home_cmd("1.8")})"
    (bin/"tomee-webprofile-startup").write_env_script libexec/"tomee-webprofile-startup", env
    (bin/"tomee-webprofile-configtest").write_env_script libexec/"bin/configtest.sh", env
  end

  def caveats; <<~EOS
    The home of Apache TomEE Web is:
      #{opt_libexec}
    To run Apache TomEE:
      #{opt_libexec}/bin/tomee-webprofile-startup
  EOS
  end

  test do
    system "#{bin}/tomee-webprofile-configtest"
  end
end
