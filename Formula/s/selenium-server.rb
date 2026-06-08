class SeleniumServer < Formula
  desc "Browser automation for testing purposes"
  homepage "https://www.selenium.dev/"
  url "https://github.com/SeleniumHQ/selenium/releases/download/selenium-4.44.0/selenium-server-4.44.0.jar"
  sha256 "a12015d1a16624bd73491536b3ebbcce6e4de1d520f5166178a232d456a46676"
  license "Apache-2.0"

  livecheck do
    url "https://www.selenium.dev/downloads/"
    regex(/href=.*?selenium-server[._-]v?(\d+(?:\.\d+)+)\.jar/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1a8a716e9affa6a270af3cadaedbd824761df7b1d15f126ae1ccd2a0fd933583"
  end

  depends_on "openjdk"

  on_linux do
    depends_on arch: :x86_64 # org.openqa.selenium.grid.config.ConfigException: No drivers for arm64 Linux
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
    spawn "#{bin}/selenium-server standalone --selenium-manager true --port #{port}"

    parsed_output = nil

    max_attempts = 100
    attempt = 0

    loop do
      attempt += 1
      break if attempt > max_attempts

      sleep 3

      output = Utils.popen_read("curl", "--silent", "localhost:#{port}/status")
      next unless $CHILD_STATUS.exitstatus.zero?

      parsed_output = JSON.parse(output)
      break if parsed_output["value"]["ready"]
    end

    refute_nil parsed_output
    assert parsed_output["value"]["ready"]
    assert_match version.to_s, parsed_output["value"]["nodes"].first["version"]
  end
end
