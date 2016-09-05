class Sjk < Formula
  desc "Swiss Java Knife"
  homepage "https://github.com/aragozin/jvm-tools"
  url "https://bintray.com/artifact/download/aragozin/generic/sjk-plus-0.4.3.jar"
  sha256 "dda1aa443c9d8a020d5a0d7d8d25170b377a620ca8497edeea078bbdd09ac8df"

  bottle :unneeded

  depends_on :java

  def install
    libexec.install "sjk-plus-#{version}.jar"
    bin.write_jar_script "#{libexec}/sjk-plus-#{version}.jar", "sjk"
  end

  test do
    system bin/"sjk", "jps"
  end
end
