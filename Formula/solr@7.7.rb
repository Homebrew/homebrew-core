class SolrAT77 < Formula
  desc "Enterprise search platform from the Apache Lucene project"
  homepage "https://lucene.apache.org/solr/"
  url "https://www.apache.org/dyn/closer.lua?path=lucene/solr/7.7.2/solr-7.7.2.tgz"
  mirror "https://archive.apache.org/dist/lucene/solr/7.7.2/solr-7.7.2.tgz"
  sha256 "eb8ee4038f25364328355de3338e46961093e39166c9bcc28b5915ae491320df"
  revision 2

  bottle :unneeded

  keg_only :versioned_formula

  depends_on "openjdk"

  def install
    pkgshare.install "bin/solr.in.sh"
    (var/"lib/solr").install "server/solr/README.txt", "server/solr/solr.xml", "server/solr/zoo.cfg"
    prefix.install %w[contrib dist server]
    libexec.install "bin"
    bin.install [libexec/"bin/solr", libexec/"bin/post", libexec/"bin/oom_solr.sh"]
    bin.env_script_all_files libexec,
      :JAVA_HOME     => Formula["openjdk"].opt_prefix,
      :SOLR_HOME     => var/"lib/solr",
      :SOLR_LOGS_DIR => var/"log/solr",
      :SOLR_PID_DIR  => var/"run/solr"
    (libexec/"bin").rmtree
  end

  def post_install
    (var/"run/solr").mkpath
    (var/"log/solr").mkpath
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/opt/solr@7.7/bin/solr start"

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
    require "socket"

    server = TCPServer.new(0)
    port = server.addr[1]
    server.close

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
