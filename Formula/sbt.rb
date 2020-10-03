class Sbt < Formula
  desc "Build tool for Scala projects"
  homepage "https://www.scala-sbt.org/"
  url "https://github.com/sbt/sbt/releases/download/v1.4.0-RC2/sbt-1.4.0-RC2.tgz"
  mirror "https://sbt-downloads.cdnedge.bluemix.net/releases/v1.4.0-RC2/sbt-1.4.0-RC2.tgz"
  sha256 "9803de74db8cf0008b051e589bffc3c1de91c4eb7b33fc12bdc567b4f0e153f9"
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

    (bin/"sbt").write <<~EOS
      #!/bin/sh
      if [ -f "$HOME/.sbtconfig" ]; then
        echo "Use of ~/.sbtconfig is deprecated, please migrate global settings to #{etc}/sbtopts" >&2
        . "$HOME/.sbtconfig"
      fi
      export JAVA_HOME="${JAVA_HOME:-#{Formula["openjdk"].opt_prefix}}"
      exec "#{libexec}/bin/sbt" "$@"
    EOS
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
    system "#{bin}/sbt", "about"
    assert_match "[info] #{version}", shell_output("#{bin}/sbt sbtVersion")
  end
end
