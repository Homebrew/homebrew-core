class Sjk < Formula
  desc "Swiss Java Knife"
  homepage "https://github.com/aragozin/jvm-tools"
  url "https://search.maven.org/remotecontent?filepath=org/gridkit/jvmtool/sjk-plus/0.10.1/sjk-plus-0.10.1.jar"
  sha256 "dafd3b18de282265fe0f806872b23211a1318fc63aaef284fbd6abee5a288368"
  revision 1

  bottle :unneeded

  depends_on "openjdk"

  def install
    libexec.install "sjk-plus-#{version}.jar"
    (bin/"sjk").write <<~EOS
      #!/bin/bash
      export JAVA_HOME="${JAVA_HOME:-#{Formula["openjdk"].opt_prefix}}"
      exec "${JAVA_HOME}/bin/java" -jar "#{libexec}/sjk-plus-#{version}.jar" "$@"
    EOS
  end

  test do
    system bin/"sjk", "jps"
  end
end
