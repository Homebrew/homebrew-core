class TomeeWebprofile < Formula
  desc "All-Apache Java EE 7 Web Profile stack"
  homepage "https://tomee.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomee/tomee-8.0.11/apache-tomee-8.0.11-webprofile.tar.gz"
  mirror "https://archive.apache.org/dist/tomee/tomee-8.0.11/apache-tomee-8.0.11-webprofile.tar.gz"
  sha256 "55fdc13771e7d97524e22a6c315594f1d8cf8a6ded088257cffdb541165128b5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c1f98888d8a277e1888a2d274bd1f764812530dc1ba2f67fb01af0832c60826f"
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
