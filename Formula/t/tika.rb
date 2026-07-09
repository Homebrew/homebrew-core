class Tika < Formula
  desc "Content analysis toolkit"
  homepage "https://tika.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tika/3.3.1/tika-app-3.3.1.jar"
  mirror "https://archive.apache.org/dist/tika/3.3.1/tika-app-3.3.1.jar"
  sha256 "0e8ee9795ac4244feab466f4a5a9c3b94675af392848243842cb6e1e69d27103"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bf8d30c4b64375e2d43616ae55121201e5ce2b19148e38cbbc947ef29c1c0e16"
  end

  depends_on "openjdk"

  resource "server" do
    url "https://www.apache.org/dyn/closer.lua?path=tika/3.3.1/tika-server-standard-3.3.1.jar"
    mirror "https://archive.apache.org/dist/tika/3.3.1/tika-server-standard-3.3.1.jar"
    sha256 "755d252de43a1995151db3a25c825332d2f27371272c41459bb5b78e21b028bd"

    livecheck do
      formula :parent
    end
  end

  def install
    odie "update `server` resource" if version != resource("server").version
    libexec.install "tika-app-#{version}.jar"
    bin.write_jar_script libexec/"tika-app-#{version}.jar", "tika"

    libexec.install resource("server")
    bin.write_jar_script libexec/"tika-server-standard-#{version}.jar", "tika-rest-server"
  end

  service do
    run [opt_bin/"tika-rest-server"]
    working_dir var/"tika"
  end

  test do
    pdf = test_fixtures("test.pdf")
    assert_equal "application/pdf\n", shell_output("#{bin}/tika --detect #{pdf}")

    port = free_port
    pid = spawn bin/"tika-rest-server", "--port=#{port}"

    sleep 10
    response = shell_output("curl -s -i http://localhost:#{port}")
    assert_match "HTTP/1.1 200 OK", response
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
