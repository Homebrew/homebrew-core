class Sjk < Formula
  desc "Swiss Java Knife"
  homepage "https://github.com/aragozin/jvm-tools"
  url "https://search.maven.org/remotecontent?filepath=org/gridkit/jvmtool/sjk-plus/0.15/sjk-plus-0.15.jar"
  sha256 "a746939cebb15a7ef682e8e9782fcf410ce426ef312d928dbb8284dc48599c4a"

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
