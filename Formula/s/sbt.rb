class Sbt < Formula
  desc "Build tool for Scala projects"
  homepage "https://www.scala-sbt.org/"
  url "https://github.com/sbt/sbt/releases/download/v1.12.11/sbt-1.12.11.tgz"
  mirror "https://sbt-downloads.cdnedge.bluemix.net/releases/v1.12.11/sbt-1.12.11.tgz"
  sha256 "5f972a79d2a5bf8f29141a74c35e686bb0860a6b6ec677af892f94cf9b124645"
  license "Apache-2.0"

  # Upstream sometimes creates releases that use a stable tag (e.g., `v1.2.3`)
  # but are labeled as "pre-release" on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d40f761ca31e4e5232e6ff1414a2f3118a36cdf84a14063162bf70a54f37380d"
  end

  depends_on "openjdk"

  def install
    inreplace "bin/sbt" do |s|
      s.gsub! 'etc_sbt_opts_file="/etc/sbt/sbtopts"', "etc_sbt_opts_file=\"#{etc}/sbtopts\""
      s.gsub! "/etc/sbt/sbtopts", "#{etc}/sbtopts"
    end

    libexec.install "bin"
    etc.install "conf/sbtopts"

    # Removes:
    # 1. `sbt.bat` (Windows-only)
    # 2. `sbtn` (pre-compiled native binary)
    # 3. `sbtn-universal-apple-darwin` (universal binary)
    (libexec/"bin").glob("sbt{.bat,n-x86_64*,n-aarch64*,n-universal-apple-darwin}").map(&:unlink)
    (bin/"sbt").write_env_script libexec/"bin/sbt", Language::Java.overridable_java_home_env
  end

  def caveats
    <<~EOS
      You can use $SBT_OPTS to pass additional JVM options to sbt.
      Project specific options should be placed in .sbtopts in the root of your project.
      Global settings should be placed in #{etc}/sbtopts

      The installation does not include `sbtn`.
    EOS
  end

  test do
    ENV.append "_JAVA_OPTIONS", "-Dsbt.log.noformat=true"
    system bin/"sbt", "--sbt-create", "about"
    assert_match version.to_s, shell_output("#{bin}/sbt sbtVersion --allow-empty")
  end
end
