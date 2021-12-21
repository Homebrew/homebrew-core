class SeleniumServer < Formula
  desc "Browser automation for testing purposes"
  homepage "https://www.selenium.dev/"
  url "https://github.com/SeleniumHQ/selenium/releases/download/selenium-4.1.0/selenium-server-4.1.1.jar"
  sha256 "6994b92fe40f535ead9ecee903988f4a990589510b1d47ed3b65b1b8b3947160"
  license "Apache-2.0"

  livecheck do
    url "https://www.selenium.dev/downloads/"
    regex(/href=.*?selenium-server[._-]v?(\d+(?:\.\d+)+)\.jar/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a96143df82bc42a3fc89ec6459245f394e7296934b1183dd85e70a3e47dab8f4"
  end

  depends_on "openjdk"

  on_linux do
    # We need to have any webdriver installed for testing,
    # macOS comes with safaridriver, let's use geckodriver for linux
    depends_on "geckodriver" => :test
  end

  def install
    libexec.install "selenium-server-#{version}.jar"
    bin.write_jar_script libexec/"selenium-server-#{version}.jar", "selenium-server"
  end

  service do
    run [opt_bin/"selenium-server", "standalone", "--port", "4444"]
    keep_alive false
    log_path var/"log/selenium-output.log"
    error_log_path var/"log/selenium-error.log"
  end

  test do
    port = free_port
    fork { exec "#{bin}/selenium-server standalone --port #{port}" }
    sleep 6
    output = shell_output("curl --silent localhost:#{port}/status")
    output = JSON.parse(output)

    assert_equal true, output["value"]["ready"]
    assert_match version.to_s, output["value"]["nodes"].first["version"]
  end
end
