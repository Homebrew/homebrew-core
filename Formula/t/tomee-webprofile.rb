class TomeeWebprofile < Formula
  desc "All-Apache Java EE 7 Web Profile stack"
  homepage "https://tomee.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomee/tomee-10.0.0/apache-tomee-10.0.0-webprofile.tar.gz"
  mirror "https://archive.apache.org/dist/tomee/tomee-10.0.0/apache-tomee-10.0.0-webprofile.tar.gz"
  sha256 "9cfe56b28cb368427415f784a8ad0e2b1c96d4f4c457fdf7971139725537c4a8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "245a50c37f9bb58eef3138913efe6ee3cb1020fb8214d21a831e7804e7d466ff"
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
