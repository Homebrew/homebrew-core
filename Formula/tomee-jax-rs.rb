class TomeeJaxRs < Formula
  desc "TomeEE Web Profile plus JAX-RS"
  homepage "https://tomee.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomee/tomee-1.7.5/apache-tomee-1.7.5-jaxrs.tar.gz"
  mirror "https://archive.apache.org/dist/tomee/tomee-1.7.5/apache-tomee-1.7.5-jaxrs.tar.gz"
  sha256 "5c9241ca683db85c13a23234b206fe98011d734a661383bbc9027deb756c09da"

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
    libexec.install_symlink "#{libexec}/bin/startup.sh" => "tomee-jax-rs-startup"
    env = Language::Java.java_home_env("1.8")
    env[:JRE_HOME] = "$(#{Language::Java.java_home_cmd("1.8")})"
    (bin/"tomee-jax-rs-startup").write_env_script libexec/"tomee-jax-rs-startup", env
    (bin/"tomee-jax-rs-configtest").write_env_script libexec/"bin/configtest.sh", env
  end

  def caveats; <<~EOS
    The home of Apache TomEE JAX-RS is:
      #{opt_libexec}
    To run Apache TomEE:
      #{opt_libexec}/bin/tomee-jax-rs-startup
  EOS
  end

  test do
    system "#{bin}/tomee-jax-rs-configtest"
  end
end
