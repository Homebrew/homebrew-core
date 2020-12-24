class Sbt < Formula
  desc "Build tool for Scala projects"
  homepage "https://www.scala-sbt.org/"
  url "https://github.com/sbt/sbt/releases/download/v1.4.6/sbt-1.4.6.tgz"
  mirror "https://sbt-downloads.cdnedge.bluemix.net/releases/v1.4.6/sbt-1.4.6.tgz"
  sha256 "86a6f28e79966074101066ab1aa19267d0c8d44eae21daa93c9c6056ca6f9da4"
  license "Apache-2.0"

  bottle :unneeded

  depends_on "openjdk"

  def install
    inreplace "bin/sbt" do |s|
      s.gsub! 'etc_sbt_opts_file="/etc/sbt/sbtopts"', "etc_sbt_opts_file=\"#{etc}/sbtopts\""
      s.gsub! "/etc/sbt/sbtopts", "#{etc}/sbtopts"
    end

    libexec.install "bin"
    etc.install "conf/sbtopts"

    (bin/"sbt").write_env_script libexec/"bin/sbt", Language::Java.overridable_java_home_env
    (bin/"sbtn").write_env_script libexec/"bin/sbtn-x86_64-apple-darwin", Language::Java.overridable_java_home_env
  end

  def caveats
    <<~EOS
      You can use $SBT_OPTS to pass additional JVM options to sbt.
      Project specific options should be placed in .sbtopts in the root of your project.
      Global settings should be placed in #{etc}/sbtopts
    EOS
  end

  test do
    ENV.append "_JAVA_OPTIONS", "-Dsbt.log.noformat=true"
    system("#{bin}/sbt", "--sbt-create", "about")
    assert_match version.to_s, shell_output("#{bin}/sbt sbtVersion")
    system "#{bin}/sbtn", "about"
    system "#{bin}/sbtn", "shutdown"
  end
end
