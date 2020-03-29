class ScmManager < Formula
  desc "Manage Git, Mercurial, and Subversion repos over HTTP"
  homepage "https://www.scm-manager.org"
  url "https://maven.scm-manager.org/nexus/content/repositories/releases/sonia/scm/scm-server/1.59/scm-server-1.59-app.tar.gz"
  sha256 "8628e82f3bfd452412260dd2d82c2e76ee57013223171f2908d75cbc6258f261"

  bottle do
    cellar :any_skip_relocation
    sha256 "521d84a5445594de2d018af2a9f0291ab0a8495e8fe878b56913ee92173a2241" => :catalina
    sha256 "d28ad275b745fb546973c9d451df374f994eaeade2d351732ab31a7141260372" => :mojave
    sha256 "42e177bd72cba3b27750308aeeaf8afa0ec8cc553b8a9acf1a02a6d5a698ce14" => :high_sierra
    sha256 "42e177bd72cba3b27750308aeeaf8afa0ec8cc553b8a9acf1a02a6d5a698ce14" => :sierra
    sha256 "42e177bd72cba3b27750308aeeaf8afa0ec8cc553b8a9acf1a02a6d5a698ce14" => :el_capitan
  end

  depends_on :java => "1.8"

  resource "client" do
    url "https://maven.scm-manager.org/nexus/content/repositories/releases/sonia/scm/clients/scm-cli-client/1.59/scm-cli-client-1.59-jar-with-dependencies.jar"
    sha256 "ac09437ae6cf20d07224895b30b23369e142055b9d1713835d8c0e3095bf68d2"
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

  def plist
    <<~EOS
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
