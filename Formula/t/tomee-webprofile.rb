class TomeeWebprofile < Formula
  desc "All-Apache Java EE 7 Web Profile stack"
  homepage "https://tomee.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomee/tomee-10.1.2/apache-tomee-10.1.2-webprofile.tar.gz"
  mirror "https://archive.apache.org/dist/tomee/tomee-10.1.2/apache-tomee-10.1.2-webprofile.tar.gz"
  sha256 "22fe8734b036fe09f7789b4bb44168a8ec7281450275a662cf15847a7ed396ac"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fc6f5b70557f903cdf24bbc42e58863ec432123865c7096e3e917dda49c21aac"
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
