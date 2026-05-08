class TomeeWebprofile < Formula
  desc "All-Apache Java EE 7 Web Profile stack"
  homepage "https://tomee.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomee/tomee-10.1.5/apache-tomee-10.1.5-webprofile.tar.gz"
  mirror "https://archive.apache.org/dist/tomee/tomee-10.1.5/apache-tomee-10.1.5-webprofile.tar.gz"
  sha256 "53a2da3872bbc20f21570bb9ba6b4c23243d57a31df2b016bb23bbc7fe831a5f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e5e4e3ecc8096540ce4946768e8e4bf93176b3159535b1acb4353d7703c95fe4"
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
