class Tika < Formula
  desc "Content analysis toolkit"
  homepage "https://tika.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tika/3.2.1/tika-app-3.2.1.jar"
  mirror "https://archive.apache.org/dist/tika/3.2.1/tika-app-3.2.1.jar"
  sha256 "268512b774a7a30e26ac1d6e3e5f7982cf6203a9822d4563be37b1922365d108"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9f9d786884111b091cf81347b58dbc73054d9e369fc41bacff434a41933f220b"
  end

  depends_on "openjdk"

  resource "server" do
    url "https://www.apache.org/dyn/closer.lua?path=tika/3.2.1/tika-server-standard-3.2.1.jar"
    mirror "https://archive.apache.org/dist/tika/3.2.1/tika-server-standard-3.2.1.jar"
    sha256 "383a8a99ec886ea95e4143bfe200208afe1884db14b4c1e470950edec82d2c5d"
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
