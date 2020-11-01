class ScmManager < Formula
  desc "Manage Git, Mercurial, and Subversion repos over HTTP"
  homepage "https://www.scm-manager.org"
  url "https://maven.scm-manager.org/nexus/content/repositories/releases/sonia/scm/scm-server/1.59/scm-server-1.59-app.tar.gz"
  sha256 "8628e82f3bfd452412260dd2d82c2e76ee57013223171f2908d75cbc6258f261"
  license "BSD-3-Clause"
  revision 1

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "243c6c1c7047996457078beedf753d836a4548696fb2a231afddba97d83b4aee" => :catalina
    sha256 "b90390788ed53f447e0c501842c7ecf99802a6a1ceeed48cbc6b7ade84e8bc31" => :mojave
    sha256 "d0999804b3919b8f6b77f4342ab7f65a22b1a27f2084f310c443eb4b80ef3642" => :high_sierra
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
