class ScmManager < Formula
  desc "Manage Git, Mercurial, and Subversion repos over HTTP"
  homepage "https://www.scm-manager.org"
  url "https://maven.scm-manager.org/nexus/content/repositories/releases/sonia/scm/scm-server/1.55/scm-server-1.55-app.tar.gz"
  sha256 "58ad12a52b2bea4cc5fb523b024f25145326e9d004cfc469f37252c65a2de6b9"

  bottle do
    cellar :any_skip_relocation
    sha256 "5fa8d7e1b0d34f144d12a252b5c731531910a7d3af459c6343ae1eb4fa5203ce" => :high_sierra
    sha256 "5fa8d7e1b0d34f144d12a252b5c731531910a7d3af459c6343ae1eb4fa5203ce" => :sierra
    sha256 "5fa8d7e1b0d34f144d12a252b5c731531910a7d3af459c6343ae1eb4fa5203ce" => :el_capitan
  end

  depends_on :java => "1.8"

  resource "client" do
    url "https://maven.scm-manager.org/nexus/content/repositories/releases/sonia/scm/clients/scm-cli-client/1.55/scm-cli-client-1.55-jar-with-dependencies.jar"
    sha256 "0dd0a56c38c02770d571ef86ab1948ff6e1d1b25b9d3d039d3565516f12086df"
  end

  def install
    rm_rf Dir["bin/*.bat"]

    libexec.install Dir["*"]

    (bin/"scm-server").write <<~EOS
      #!/bin/bash
      BASEDIR="#{libexec}"
      REPO="#{libexec}/lib"
      export JAVA_HOME=$(#{Language::Java.java_home_cmd("1.8")})
      "#{libexec}/bin/scm-server" "$@"
    EOS
    chmod 0755, bin/"scm-server"

    tools = libexec/"tools"
    tools.install resource("client")

    scm_cli_client = bin/"scm-cli-client"
    scm_cli_client.write <<~EOS
      #!/bin/bash
      export JAVA_HOME=$(#{Language::Java.java_home_cmd("1.8")})
      java -jar "#{tools}/scm-cli-client-#{version}-jar-with-dependencies.jar" "$@"
    EOS
    chmod 0755, scm_cli_client
  end

  plist_options :manual => "scm-server start"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/scm-server</string>
          <string>start</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/scm-cli-client version")
  end
end
