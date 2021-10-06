class Verapdf < Formula
  desc "Industry supported, open source PDF/A validation GUI and CUI"
  homepage "https://software.verapdf.org/"
  url "https://github.com/veraPDF/veraPDF-apps/archive/refs/tags/v1.19.198.tar.gz"
  sha256 "6a29db1e015db51f31eac46da47ce10ac8b953971b142d440ed89323eede9f7d"
  license any_of: ["GPL-3.0-or-later", "MPL-2.0"]

  depends_on "maven" => :build
  depends_on "openjdk@11"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk@11"].opt_prefix

    system "mvn", "--projects", "greenfield-apps,gui", "clean", "package"
    libexec.install Dir["greenfield-apps/target/greenfield-apps-*-SNAPSHOT.jar"].first => "greenfield-apps-#{version}.jar"
    (bin/"verapdf").write <<~EOS
      #!/bin/bash
      export JAVA_HOME="#{Language::Java.overridable_java_home_env("11")[:JAVA_HOME]}"
      exec "${JAVA_HOME}/bin/java" -classpath "#{libexec/"greenfield-apps-#{version}.jar"}" org.verapdf.apps.GreenfieldCliWrapper "$@"
    EOS
    (bin/"verapdf-gui").write <<~EOS
      #!/bin/bash
      export JAVA_HOME="#{Language::Java.overridable_java_home_env("11")[:JAVA_HOME]}"
      exec "${JAVA_HOME}/bin/java" -classpath "#{libexec/"greenfield-apps-#{version}.jar"}" org.verapdf.apps.GreenfieldGuiWrapper --frameScale 1.0 "$@"
    EOS
  end

  test do
    system bin/"verapdf", "--version"
  end
end
