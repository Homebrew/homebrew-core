class Sbt < Formula
  desc "Build tool for Scala projects"
  homepage "http://www.scala-sbt.org"
  url "https://dl.bintray.com/sbt/native-packages/sbt/0.13.12/sbt-0.13.12.tgz"
  sha256 "280230f9c3f42a4af5699effff8425e08b6f47da72dfaa59e9b7ad0e6d6203df"

  devel do
    url "https://dl.bintray.com/sbt/native-packages/sbt/1.0.0-M4/sbt-1.0.0-M4.tgz"
    sha256 "8cb2eaabcbfeceeb65023311b08c980feff80552b22524213c71857ced2f8de7"
    version "1.0.0-M4"
  end

  bottle :unneeded

  depends_on :java => "1.6+"

  def install
    inreplace "bin/sbt" do |s|
      s.gsub! 'etc_sbt_opts_file="${sbt_home}/conf/sbtopts"', "etc_sbt_opts_file=\"#{etc}/sbtopts\""
      s.gsub! "/etc/sbt/sbtopts", "#{etc}/sbtopts"
    end

    inreplace "bin/sbt-launch-lib.bash", "${sbt_home}/bin/sbt-launch.jar", "#{libexec}/sbt-launch.jar"

    libexec.install "bin/sbt", "bin/sbt-launch-lib.bash", "bin/sbt-launch.jar"
    etc.install "conf/sbtopts"

    (bin/"sbt").write <<-EOS.undent
      #!/bin/sh
      if [ -f "$HOME/.sbtconfig" ]; then
        echo "Use of ~/.sbtconfig is deprecated, please migrate global settings to #{etc}/sbtopts" >&2
        . "$HOME/.sbtconfig"
      fi
      exec "#{libexec}/sbt" "$@"
    EOS
  end

  def caveats;  <<-EOS.undent
    You can use $SBT_OPTS to pass additional JVM options to SBT:
       SBT_OPTS="-XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=256M"

    This formula is now using the standard typesafe sbt launcher script.
    Project specific options should be placed in .sbtopts in the root of your project.
    Global settings should be placed in #{etc}/sbtopts
    EOS
  end

  test do
    ENV["_JAVA_OPTIONS"] = "-Dsbt.log.noformat=true"
    ENV.java_cache
    output = shell_output("#{bin}/sbt sbt-version")
    assert_match "[info] #{version}", output
  end
end
