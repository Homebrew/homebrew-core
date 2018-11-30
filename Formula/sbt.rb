class Sbt < Formula
  desc "Build tool for Scala projects"
  homepage "https://www.scala-sbt.org/"
  url "https://github.com/sbt/sbt/releases/download/v1.2.7/sbt-1.2.7.tgz"
  mirror "https://sbt-downloads.cdnedge.bluemix.net/releases/v1.2.7/sbt-1.2.7.tgz"
  sha256 "2625cbd8db75ec9b4a57e9a0af55a5ee8ad7700e1eba7d97ad78d9296450e781"

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    inreplace "bin/sbt" do |s|
      s.gsub! 'etc_sbt_opts_file="/etc/sbt/sbtopts"', "etc_sbt_opts_file=\"#{etc}/sbtopts\""
      s.gsub! "/etc/sbt/sbtopts", "#{etc}/sbtopts"
    end

    libexec.install "bin", "lib"
    etc.install "conf/sbtopts"

    (bin/"sbt").write <<~EOS
      #!/bin/sh
      if [ -f "$HOME/.sbtconfig" ]; then
        echo "Use of ~/.sbtconfig is deprecated, please migrate global settings to #{etc}/sbtopts" >&2
        . "$HOME/.sbtconfig"
      fi
      exec "#{libexec}/bin/sbt" "$@"
    EOS
  end

  def caveats;  <<~EOS
    You can use $SBT_OPTS to pass additional JVM options to sbt.
    Project specific options should be placed in .sbtopts in the root of your project.
    Global settings should be placed in #{etc}/sbtopts
  EOS
  end

  test do
    ENV.append "_JAVA_OPTIONS", "-Dsbt.log.noformat=true"
    assert_match "[info] #{version}", shell_output("#{bin}/sbt sbtVersion")
  end
end
