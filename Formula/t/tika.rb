class Tika < Formula
  desc "Content analysis toolkit"
  homepage "https://tika.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tika/3.2.0/tika-app-3.2.0.jar"
  mirror "https://archive.apache.org/dist/tika/3.2.0/tika-app-3.2.0.jar"
  sha256 "1056397a40cefbb45952a379075c54b7f8dff244d4ad5ec3c785d8a110d4f533"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "490308b0b85126911c6affedad427a6dba3be0502f23ec85f3b27728f500d044"
  end

  depends_on "openjdk"

  resource "server" do
    url "https://www.apache.org/dyn/closer.lua?path=tika/3.2.0/tika-server-standard-3.2.0.jar"
    mirror "https://archive.apache.org/dist/tika/3.2.0/tika-server-standard-3.2.0.jar"
    sha256 "60cc16fc933ee47f94e9f4a56e8d6f9554e0caf14facf896d9727b1e834224c1"
  end

  def install
    libexec.install "tika-app-#{version}.jar"
    bin.write_jar_script libexec/"tika-app-#{version}.jar", "tika"

    libexec.install resource("server")
    bin.write_jar_script libexec/"tika-server-standard-#{version}.jar", "tika-rest-server"
  end

  service do
    run [opt_bin/"tika-rest-server"]
    working_dir HOMEBREW_PREFIX
  end

  test do
    assert_match version.to_s, resource("server").version.to_s, "server resource out of sync with formula"
    pdf = test_fixtures("test.pdf")
    assert_equal "application/pdf\n", shell_output("#{bin}/tika --detect #{pdf}")

    port = free_port
    pid = fork do
      exec bin/"tika-rest-server", "--port=#{port}"
    end

    sleep 10
    response = shell_output("curl -s -i http://localhost:#{port}")
    assert_match "HTTP/1.1 200 OK", response
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
