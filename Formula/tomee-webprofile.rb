class TomeeWebprofile < Formula
  desc "All-Apache Java EE 7 Web Profile stack"
  homepage "https://tomee.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=tomee/tomee-7.1.1/apache-tomee-7.1.1-webprofile.tar.gz"
  sha256 "1bb495c47cd6b4ce476fa1701becf31af81046efcf86a7df446e7a9a4c67e304"

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
