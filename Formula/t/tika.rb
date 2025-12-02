class Tika < Formula
  desc "Content analysis toolkit"
  homepage "https://tika.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tika/3.2.3/tika-app-3.2.3.jar"
  mirror "https://archive.apache.org/dist/tika/3.2.3/tika-app-3.2.3.jar"
  sha256 "80c20c085e2c0976bbd55969e5bf90dda2b7155db31068639fbc871d0369e7e7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "16c85f0ebf19e98b151a9f7885619440592718925034cc969536ade1805bdea4"
  end

  depends_on "openjdk"

  resource "server" do
    url "https://www.apache.org/dyn/closer.lua?path=tika/3.2.3/tika-server-standard-3.2.3.jar"
    mirror "https://archive.apache.org/dist/tika/3.2.3/tika-server-standard-3.2.3.jar"
    sha256 "c00898065af088925ba4b65856db66e6140e4c750d28219b61b96885885e7593"

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
