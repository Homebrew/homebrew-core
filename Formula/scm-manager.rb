class ScmManager < Formula
  desc "Manage Git, Mercurial, and Subversion repos over HTTP"
  homepage "https://www.scm-manager.org"
  url "https://maven.scm-manager.org/nexus/content/repositories/releases/sonia/scm/scm-server/1.59/scm-server-1.59-app.tar.gz"
  sha256 "8628e82f3bfd452412260dd2d82c2e76ee57013223171f2908d75cbc6258f261"
  license "BSD-3-Clause"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "0bf3a43daf080e5b84cd36512b28bc13c5ac74c24c711436358d00e060f84a86" => :big_sur
    sha256 "a7d1d6994937ca3170f5bc078886339910520eb1261b835c9c6f1173fe9d5496" => :catalina
    sha256 "6b0ed9e9d667ec92070b3f4b53f9dc90cbb508d2c6649684f39182e3bb23d6ac" => :mojave
    sha256 "3e71fdc3039b4cc46fbbb49ae7976b8be09d8b9c4f6e5c0e052d30016668ac74" => :high_sierra
  end

  depends_on "openjdk@8"

  resource "client" do
    url "https://maven.scm-manager.org/nexus/content/repositories/releases/sonia/scm/clients/scm-cli-client/1.59/scm-cli-client-1.59-jar-with-dependencies.jar"
    sha256 "ac09437ae6cf20d07224895b30b23369e142055b9d1713835d8c0e3095bf68d2"
  end

  def install
    rm_rf Dir["bin/*.bat"]

    libexec.install Dir["*"]

    env = Language::Java.overridable_java_home_env("1.8")
    env["BASEDIR"] = libexec
    env["REPO"] = libexec/"lib"
    (bin/"scm-server").write_env_script libexec/"bin/scm-server", env

    (libexec/"tools").install resource("client")
    bin.write_jar_script libexec/"tools/scm-cli-client-#{version}-jar-with-dependencies.jar", "scm-cli-client", java_version: "1.8"
  end

  plist_options manual: "scm-server start"

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
