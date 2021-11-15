class Sbt < Formula
  desc "Build tool for Scala projects"
  homepage "https://www.scala-sbt.org/"
  url "https://github.com/sbt/sbt/releases/download/v1.5.5/sbt-1.5.5.tgz"
  mirror "https://sbt-downloads.cdnedge.bluemix.net/releases/v1.5.5/sbt-1.5.5.tgz"
  sha256 "c0fcd50cf5c91ed27ad01c5c6a8717b62700c87a50ff9b0e7573b227acb2b3c9"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4ff6b167b5ed75da37702d38836642b870c5ae819b26e64fbbdb670abfb6ccc8"
    sha256 cellar: :any_skip_relocation, big_sur:       "4ff6b167b5ed75da37702d38836642b870c5ae819b26e64fbbdb670abfb6ccc8"
    sha256 cellar: :any_skip_relocation, catalina:      "4ff6b167b5ed75da37702d38836642b870c5ae819b26e64fbbdb670abfb6ccc8"
    sha256 cellar: :any_skip_relocation, mojave:        "4ff6b167b5ed75da37702d38836642b870c5ae819b26e64fbbdb670abfb6ccc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "349fea6916cedb16eb1b9c4e96dd7ecbcd6a9db58522a6124f248b68f38c3f30"
    sha256 cellar: :any_skip_relocation, all:           "71e7470db1315a7bc95402092f0888bf04d1b8548b0f1ea04b1cfd7600402288"
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
    (libexec/"bin").glob("sbt{.bat,n-x86_64*}").map(&:unlink)
    (bin/"sbt").write_env_script libexec/"bin/sbt", Language::Java.overridable_java_home_env
  end

  def caveats
    <<~EOS
      You can use $SBT_OPTS to pass additional JVM options to sbt.
      Project specific options should be placed in .sbtopts in the root of your project.
      Global settings should be placed in #{etc}/sbtopts

      #{tap.user}'s installation does not include `sbtn`.
    EOS
  end

  test do
    ENV.append "_JAVA_OPTIONS", "-Dsbt.log.noformat=true"
    system bin/"sbt", "--sbt-create", "about"
    assert_match version.to_s, shell_output("#{bin}/sbt sbtVersion")
  end
end
