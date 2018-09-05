class TomeeWebprofile < Formula
  desc "All-Apache Java EE 6 Web Profile stack"
  homepage "https://tomee.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=tomee/tomee-1.7.4/apache-tomee-1.7.4-webprofile.tar.gz"
  sha256 "4a1c13e60fcf1289980b0c14f8e67daf31b1c91f4e208fbc7aeec0a252655897"
  revision 1

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
