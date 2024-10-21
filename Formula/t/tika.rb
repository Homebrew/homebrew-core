class Tika < Formula
  desc "Content analysis toolkit"
  homepage "https://tika.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tika/3.0.0/tika-app-3.0.0.jar"
  mirror "https://archive.apache.org/dist/tika/3.0.0/tika-app-3.0.0.jar"
  sha256 "f2c156533fac004d3d30d322555bb1f2581a104558a913bfc74d8c48dcf4541c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "44d1913c695f5523d72c1336e0182b1fe0f5f38362d49c8b783fe1d10d266037"
  end

  depends_on "openjdk"

  resource "server" do
    url "https://www.apache.org/dyn/closer.lua?path=tika/3.0.0/tika-server-standard-3.0.0.jar"
    mirror "https://archive.apache.org/dist/tika/3.0.0/tika-server-standard-3.0.0.jar"
    sha256 "53851c4f326c0bdd7e1a9ba77bb35193d431d9dc1898e263e0b7bb337f03e2c1"
  end

  def install
    libexec.install "tika-app-#{version}.jar"
    bin.write_jar_script libexec/"tika-app-#{version}.jar", "tika"

    libexec.install resource("server")
    bin.write_jar_script libexec/"tika-server-standard-#{version}.jar", "tika-rest-server"
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
