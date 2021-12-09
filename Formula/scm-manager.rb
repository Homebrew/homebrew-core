class ScmManager < Formula
  desc "Manage Git, Mercurial, and Subversion repos over HTTP"
  homepage "https://www.scm-manager.org"
  url "https://maven.scm-manager.org/nexus/content/repositories/releases/sonia/scm/scm-server/1.59/scm-server-1.59-app.tar.gz"
  sha256 "8628e82f3bfd452412260dd2d82c2e76ee57013223171f2908d75cbc6258f261"
  license "BSD-3-Clause"
  revision 1

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "f67a33413e0dc33d7f3f964786e23fa173ffb2c8f7ea0498c31c7ac670ece038"
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

  service do
    run [opt_bin/"scm-server", "start"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/scm-cli-client version")
  end
end
