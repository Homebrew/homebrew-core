class Sbt < Formula
  desc "Build tool for Scala projects"
  homepage "http://www.scala-sbt.org"
  url "https://github.com/sbt/sbt/releases/download/v0.13.15/sbt-0.13.15.tgz"
  sha256 "b6e073d7c201741dcca92cfdd1dd3cd76c42a47dc9d8c8ead8df7117deed7aef"

  devel do
    url "https://github.com/sbt/sbt/releases/download/v1.0.0-M5/sbt-1.0.0-M5.tgz"
    sha256 "06340442a3d6872dbdaceb3cb09e6812838a93da121954cfa8a2e07b1b527c74"
    version "1.0.0-M5"
  end

  bottle :unneeded

  depends_on :java => "1.6+"

  def install
    inreplace "bin/sbt" do |s|
      s.gsub! 'etc_sbt_opts_file="${sbt_home}/conf/sbtopts"', "etc_sbt_opts_file=\"#{etc}/sbtopts\""
      s.gsub! "/etc/sbt/sbtopts", "#{etc}/sbtopts"
    end

    if build.stable? # Remove this `inreplace` when stable > 0.13.15
      inreplace "bin/sbt-launch-lib.bash" do |s|
        # Upstream issue "Replace realpath with something Mac compatible"
        # Reported 10 Apr 2017 https://github.com/sbt/sbt-launcher-package/issues/149
        s.gsub! "$(dirname \"$(realpath \"$0\")\")", "#{libexec}/bin"
        s.gsub! "$(dirname \"$sbt_bin_dir\")", libexec
        # Workaround for `brew test sbt` failing to detect java -version
        # Reported 10 Apr 2017 https://github.com/sbt/sbt-launcher-package/issues/150
        s.gsub! "[[ \"$java_version\" > \"8\" ]]", "[[ \"$java_version\" == \"9\" ]]"
      end
    end

    libexec.install "bin", "lib"
    etc.install "conf/sbtopts"

    (bin/"sbt").write <<-EOS.undent
      #!/bin/sh
      if [ -f "$HOME/.sbtconfig" ]; then
        echo "Use of ~/.sbtconfig is deprecated, please migrate global settings to #{etc}/sbtopts" >&2
        . "$HOME/.sbtconfig"
      fi
      exec "#{libexec}/bin/sbt" "$@"
    EOS
  end

  def caveats;  <<-EOS.undent
    You can use $SBT_OPTS to pass additional JVM options to SBT:
       SBT_OPTS="-XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=256M"

    This formula is now using the standard lightbend sbt launcher script.
    Project specific options should be placed in .sbtopts in the root of your project.
    Global settings should be placed in #{etc}/sbtopts
    EOS
  end

  test do
    ENV["_JAVA_OPTIONS"] = "-Dsbt.log.noformat=true"
    ENV.java_cache
    assert_match "[info] #{version}", shell_output("#{bin}/sbt sbtVersion")
  end
end
