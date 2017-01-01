class Sjk < Formula
  desc "Swiss Java Knife"
  homepage "https://github.com/aragozin/jvm-tools"
  url "https://github.com/aragozin/jvm-tools/archive/jvmtool-umbrella-pom-0.4.4.tar.gz"
  sha256 "d022fb266d86aa2325b9b76f53754a46daf8635ef4004e4b28e4d068f0461f3b"

  bottle do
    cellar :any_skip_relocation
    sha256 "35650f5840bde9a62b05bc660b3f2c38b551d0bda6d3fa666e79e49cb4f4b646" => :sierra
    sha256 "e965cfbe1287adc7f55324b9a3209718a55b6464ff695bb6b648c28674270dd1" => :el_capitan
    sha256 "2b0057a4934ed28ae2f8d9d02f871f3f6ec3d0645a34087460bd68817e34e434" => :yosemite
  end

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
