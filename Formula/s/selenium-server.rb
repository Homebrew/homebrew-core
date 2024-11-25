class SeleniumServer < Formula
  desc "Browser automation for testing purposes"
  homepage "https://www.selenium.dev/"
  url "https://github.com/SeleniumHQ/selenium/releases/download/selenium-4.26.0/selenium-server-4.26.0.jar"
  sha256 "19138985733452abe00339350fd74571a43d11ef8aad55a29c18d33f326ccf0a"
  license "Apache-2.0"

  livecheck do
    url "https://www.selenium.dev/downloads/"
    regex(/href=.*?selenium-server[._-]v?(\d+(?:\.\d+)+)\.jar/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5d828e053819cabafc97a21eea4b409bed8d7cfc46690b35643b0b4041fd9584"
  end

  depends_on "openjdk"

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
