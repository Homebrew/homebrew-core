class SolrAT77 < Formula
  desc "Enterprise search platform from the Apache Lucene project"
  homepage "https://lucene.apache.org/solr/"
  url "https://www.apache.org/dyn/closer.lua?path=lucene/solr/7.7.3/solr-7.7.3.tgz"
  mirror "https://archive.apache.org/dist/lucene/solr/7.7.3/solr-7.7.3.tgz"
  sha256 "3ec67fa430afa5b5eb43bb1cd4a659e56ee9f8541e0116d6080c0d783870baee"
  license "Apache-2.0"
  revision 1

  # Remove the `livecheck` block (so the check is automatically skipped) once
  # the 7.7.x series is reported as EOL on the first-party downloads page:
  # https://lucene.apache.org/solr/downloads.html#about-versions-and-support
  livecheck do
    url "https://lucene.apache.org/solr/downloads.html"
    regex(/href=.*?solr[._-]v?(7(?:\.\d+)*)\.t/i)
  end

  bottle :unneeded

  keg_only :versioned_formula

  depends_on "openjdk@11"

  def install
    pkgshare.install "bin/solr.in.sh"
    (var/"lib/solr").install "server/solr/README.txt", "server/solr/solr.xml", "server/solr/zoo.cfg"
    prefix.install %w[contrib dist server]
    libexec.install "bin"
    bin.install [libexec/"bin/solr", libexec/"bin/post", libexec/"bin/oom_solr.sh"]

    env = Language::Java.overridable_java_home_env("11")
    env["SOLR_HOME"] = "${SOLR_HOME:-#{var/"lib/solr"}}"
    env["SOLR_LOGS_DIR"] = "${SOLR_LOGS_DIR:-#{var/"log/solr"}}"
    env["SOLR_PID_DIR"] = "${SOLR_PID_DIR:-#{var/"run/solr"}}"
    bin.env_script_all_files libexec, env
    (libexec/"bin").rmtree
  end

  def post_install
    (var/"run/solr").mkpath
    (var/"log/solr").mkpath
  end

  plist_options manual: "#{HOMEBREW_PREFIX}/opt/solr@7.7/bin/solr start"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/solr</string>
            <string>start</string>
            <string>-f</string>
          </array>
          <key>ServiceDescription</key>
          <string>#{name}</string>
          <key>WorkingDirectory</key>
          <string>#{HOMEBREW_PREFIX}</string>
          <key>RunAtLoad</key>
          <true/>
      </dict>
      </plist>
    EOS
  end

  test do
    ENV["SOLR_PID_DIR"] = testpath
    port = free_port

    # Info detects no Solr node => exit code 3
    shell_output(bin/"solr -i", 3)
    # Start a Solr node => exit code 0
    shell_output(bin/"solr start -p #{port} -Djava.io.tmpdir=/tmp")
    # Info detects a Solr node => exit code 0
    shell_output(bin/"solr -i")
    # Impossible to start a second Solr node on the same port => exit code 1
    shell_output(bin/"solr start -p #{port}", 1)
    # Stop a Solr node => exit code 0
    shell_output(bin/"solr stop -p #{port}")
    # No Solr node left to stop => exit code 1
    shell_output(bin/"solr stop -p #{port}", 1)
  end
end
