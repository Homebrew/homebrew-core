class Sbt < Formula
  desc "Build tool for Scala projects"
  homepage "https://www.scala-sbt.org/"
  url "https://github.com/sbt/sbt/releases/download/v1.0.3/sbt-1.0.3.tgz"
  sha256 "2374bf494132e7bf316fa2b83155f166fdf6b042ad70fa681e51e3fe8ad82c10"

  bottle :unneeded

  # Set to 1.8+ for > 1.0.3; Java 9 compat https://github.com/sbt/launcher/pull/45
  depends_on :java => "1.8"

  def install
    inreplace "bin/sbt" do |s|
      s.gsub! 'etc_sbt_opts_file="/etc/sbt/sbtopts"', "etc_sbt_opts_file=\"#{etc}/sbtopts\""
      s.gsub! "/etc/sbt/sbtopts", "#{etc}/sbtopts"
    end

    libexec.install "bin", "lib"
    etc.install "conf/sbtopts"
    (bin/"sbt").write_env_script libexec/"bin/sbt", Language::Java.java_home_env("1.8")
  end

  def caveats;  <<~EOS
    You can use $SBT_OPTS to pass additional JVM options to SBT:
       SBT_OPTS="-XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=256M"

    This formula uses the standard Lightbend sbt launcher script.
    Project specific options should be placed in .sbtopts in the root of your project.
    Global settings should be placed in #{etc}/sbtopts
    EOS
  end

  test do
    ENV.append "_JAVA_OPTIONS", "-Dsbt.log.noformat=true"
    assert_match "[info] #{version}", shell_output("#{bin}/sbt sbtVersion")
  end
end
