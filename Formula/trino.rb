class Trino < Formula
  desc "Distributed SQL query engine for big data"
  homepage "https://trino.io"
  url "https://search.maven.org/remotecontent?filepath=io/trino/trino-server/351/trino-server-351.tar.gz"
  sha256 "e4d50a4179868ee08dd879a50b6c9e2cadf3e7ccce93c6fe9b40f8f7f973e158"
  license "Apache-2.0"

  bottle :unneeded

  depends_on "openjdk"

  resource "trino-cli" do
    url "https://search.maven.org/remotecontent?filepath=io/trino/trino-cli/351/trino-cli-351-executable.jar"
    sha256 "f525c91d2872a9bad7cc5bd83131eba30ef48c3e61378858c5a2d8471bc03605"
  end

  def install
    libexec.install Dir["*"]

    (libexec/"etc/node.properties").write <<~EOS
      node.environment=dev
      node.id=dev
      node.data-dir=#{var}/trino/data
    EOS

    (libexec/"etc/jvm.config").write <<~EOS
      -XX:+UseG1GC
      -XX:G1HeapRegionSize=32M
      -XX:+ExplicitGCInvokesConcurrent
      -XX:+ExitOnOutOfMemoryError
      -Djdk.attach.allowAttachSelf=true
    EOS

    (libexec/"etc/config.properties").write <<~EOS
      coordinator=true
      node-scheduler.include-coordinator=true
      http-server.http.port=8080
      query.max-memory=1GB
      query.max-memory-per-node=1GB
      discovery-server.enabled=true
      discovery.uri=http://localhost:8080
    EOS

    (libexec/"etc/log.properties").write <<~EOS
      io.trino=INFO
    EOS

    (libexec/"etc/catalog/jmx.properties").write <<~EOS
      connector.name=jmx
    EOS

    (bin/"trino-server").write_env_script libexec/"bin/launcher", Language::Java.overridable_java_home_env

    resource("trino-cli").stage do
      libexec.install "trino-cli-#{version}-executable.jar"
      bin.write_jar_script libexec/"trino-cli-#{version}-executable.jar", "trino"
    end
  end

  def post_install
    (var/"trino/data").mkpath
  end

  def caveats
    <<~EOS
      Add connectors to #{opt_libexec}/etc/catalog/. See:
      https://trino.io/docs/current/connector.html
    EOS
  end

  plist_options manual: "trino-server run"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
      "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>RunAtLoad</key>
          <true/>
          <key>AbandonProcessGroup</key>
          <true/>
          <key>WorkingDirectory</key>
          <string>#{opt_libexec}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/trino-server</string>
            <string>run</string>
          </array>
        </dict>
      </plist>
    EOS
  end

  test do
    system bin/"trino-server", "run", "--help"
    assert_match "Trino CLI #{version}", shell_output("#{bin}/trino --version").chomp
  end
end
