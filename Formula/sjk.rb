class Sjk < Formula
  desc "Swiss Java Knife"
  homepage "https://github.com/aragozin/jvm-tools"
  url "https://github.com/aragozin/jvm-tools/archive/jvmtool-umbrella-pom-0.4.4.tar.gz"
  sha256 "d022fb266d86aa2325b9b76f53754a46daf8635ef4004e4b28e4d068f0461f3b"

  depends_on "maven" => :build
  depends_on :java

  def install
    ENV.java_cache
    system "mvn", "clean", "package"
    cd "sjk-plus/target" do
      libexec.install "sjk-plus-#{version}.jar"
      bin.write_jar_script "#{libexec}/sjk-plus-#{version}.jar", "sjk"
    end
  end

  test do
    system bin/"sjk", "jps"
  end
end
