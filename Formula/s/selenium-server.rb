class SeleniumServer < Formula
  desc "Browser automation for testing purposes"
  homepage "https://www.selenium.dev/"
  url "https://github.com/SeleniumHQ/selenium/releases/download/selenium-4.12.0/selenium-server-4.12.1.jar"
  sha256 "b6b0ccf4c3accff938d2d9b2b13ce8f0ed0b8113d0840d6bc705e383f41d6c26"
  license "Apache-2.0"

  livecheck do
    url "https://www.selenium.dev/downloads/"
    regex(/href=.*?selenium-server[._-]v?(\d+(?:\.\d+)+)\.jar/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a8de811c0a5922437f34774efbdd77559d6f26c48aca4ac97c7925b5faa09fd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a8de811c0a5922437f34774efbdd77559d6f26c48aca4ac97c7925b5faa09fd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4a8de811c0a5922437f34774efbdd77559d6f26c48aca4ac97c7925b5faa09fd"
    sha256 cellar: :any_skip_relocation, ventura:        "4a8de811c0a5922437f34774efbdd77559d6f26c48aca4ac97c7925b5faa09fd"
    sha256 cellar: :any_skip_relocation, monterey:       "4a8de811c0a5922437f34774efbdd77559d6f26c48aca4ac97c7925b5faa09fd"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a8de811c0a5922437f34774efbdd77559d6f26c48aca4ac97c7925b5faa09fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0bfa91930f9679f92b03054e0401b1dbe6372c101e36ba7f593888e345b21085"
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
    fork { exec "#{bin}/selenium-server standalone --selenium-manager true --port #{port}" }

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

    assert !parsed_output.nil?
    assert parsed_output["value"]["ready"]
    assert_match version.to_s, parsed_output["value"]["nodes"].first["version"]
  end
end
