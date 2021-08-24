class SeleniumServerStandalone < Formula
  desc "Browser automation for testing purposes"
  homepage "https://www.seleniumhq.org/"
  url "https://selenium-release.storage.googleapis.com/3.141/selenium-server-standalone-3.141.59.jar"
  sha256 "acf71b77d1b66b55db6fb0bed6d8bae2bbd481311bcbedfeff472c0d15e8f3cb"
  license "Apache-2.0"
  revision 2

  livecheck do
    url "https://www.selenium.dev/downloads/"
    regex(/href=.*?selenium-server-standalone[._-]v?(\d+(?:\.\d+)+)\.jar/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5a2d805f6a197441039bd29d284192ecefefdd4e5bc3e84395a87ce19705dc4c"
  end

  depends_on "openjdk"

  def install
    libexec.install "selenium-server-standalone-#{version}.jar"
    bin.write_jar_script libexec/"selenium-server-standalone-#{version}.jar", "selenium-server"
  end

  service do
    run [opt_bin/"selenium-server", "-port", "4444"]
    keep_alive false
    log_path var/"log/selenium-output.log"
    error_log_path var/"log/selenium-error.log"
  end

  test do
    port = free_port
    fork { exec "#{bin}/selenium-server -port #{port}" }
    sleep 6
    output = shell_output("curl --silent localhost:#{port}/wd/hub/status")
    output = JSON.parse(output)

    assert_equal 0, output["status"]
    assert_equal true, output["value"]["ready"]
    assert_equal version, output["value"]["build"]["version"]
  end
end
