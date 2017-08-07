class Sbt < Formula
  desc "Build tool for Scala projects"
  homepage "http://www.scala-sbt.org"
  url "https://dl.bintray.com/homebrew/mirror/sbt-0.13.16"
  mirror "https://cocl.us/sbt01316tgz"
  sha256 "22729580a581e966259267eda4d937a2aecad86848f8a82fcc716dcae8dc760c"

  devel do
    url "https://github.com/sbt/sbt/releases/download/v1.0.0-RC2/sbt-1.0.0-RC2.tgz"
    sha256 "4e446c49a473d9ae5001e6ec847c06b76e3d27f34d680ae7bd258709547630d7"
  end

  bottle :unneeded

  depends_on :java => "1.6+"

  def install
    inreplace "bin/sbt" do |s|
      s.gsub! 'etc_sbt_opts_file="${sbt_home}/conf/sbtopts"', "etc_sbt_opts_file=\"#{etc}/sbtopts\""
      s.gsub! "/etc/sbt/sbtopts", "#{etc}/sbtopts"
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

    This formula uses the standard Lightbend sbt launcher script.
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
