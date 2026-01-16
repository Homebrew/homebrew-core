class TomeeWebprofile < Formula
  desc "All-Apache Java EE 7 Web Profile stack"
  homepage "https://tomee.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomee/tomee-10.1.3/apache-tomee-10.1.3-webprofile.tar.gz"
  mirror "https://archive.apache.org/dist/tomee/tomee-10.1.3/apache-tomee-10.1.3-webprofile.tar.gz"
  sha256 "d308885f37e0c9574d5c3effd091dfde1bda423ddf47c160c4d4916094cb79ff"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ffd83d12691e3fa08981b9c9d91bc5e3572672cd84ab55cf64e7e09d9560c90f"
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
