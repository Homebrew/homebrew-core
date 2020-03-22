class SbtAT013 < Formula
  desc "Build tool for Scala projects"
  homepage "https://www.scala-sbt.org/"
  url "https://github.com/sbt/sbt/releases/download/v0.13.18/sbt-0.13.18.tgz"
  sha256 "afe82322ca8e63e6f1e10fc1eb515eb7dc6c3e5a7f543048814072a03d83b331"

  bottle :unneeded

  keg_only :versioned_formula

  depends_on :java => "1.8"

  def install
    inreplace "bin/sbt" do |s|
      s.gsub! 'etc_sbt_opts_file="/etc/sbt/sbtopts"', "etc_sbt_opts_file=\"#{etc}/sbtopts\""
      s.gsub! "/etc/sbt/sbtopts", "#{etc}/sbtopts"
    end

    libexec.install "bin", "lib"
    etc.install "conf/sbtopts"

    (bin/"sbt").write <<~EOS
      #!/bin/sh
      export JAVA_HOME=$(#{Language::Java.java_home_cmd("1.8")})
      if [ -f "$HOME/.sbtconfig" ]; then
        echo "Use of ~/.sbtconfig is deprecated, please migrate global settings to #{etc}/sbtopts" >&2
        . "$HOME/.sbtconfig"
      fi
      exec "#{libexec}/bin/sbt" "$@"
    EOS
  end

  def caveats
    <<~EOS
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
