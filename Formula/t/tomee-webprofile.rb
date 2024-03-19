class TomeeWebprofile < Formula
  desc "All-Apache Java EE 7 Web Profile stack"
  homepage "https://tomee.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomee/tomee-9.1.2/apache-tomee-9.1.2-webprofile.tar.gz"
  mirror "https://archive.apache.org/dist/tomee/tomee-9.1.2/apache-tomee-9.1.2-webprofile.tar.gz"
  sha256 "1e23599e075415bf35ef993e975a7ea7ae49bc12683c07c5cfc9adb6a66e84af"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d5826c2ba60685ddb8019dc01ab3f8d8ab8d8b65830e3024f28c410d008bbc19"
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
