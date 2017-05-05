class Sjk < Formula
  desc "Swiss Java Knife"
  homepage "https://github.com/aragozin/jvm-tools"
  url "https://github.com/aragozin/jvm-tools/archive/jvmtool-umbrella-pom-0.5.1.tar.gz"
  sha256 "d6e34a7e9ce8a094bcf8b5ceab092c04a7307a9a4e7eca0005b7d4f70dd98942"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "298ca4cf2da2d45f3c2a67c7f31ab172b747c2388d97cd475e269e52c8525deb" => :sierra
    sha256 "24271d45fbf4f2ad5d4ae008f95e4fdb4dfbe3afde349ac429984914526bc0f2" => :el_capitan
    sha256 "d83e89c35dff7eabd7dee175fe6fa2f3d1fc72abdccedfff6e3205ed4cbc5405" => :yosemite
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
