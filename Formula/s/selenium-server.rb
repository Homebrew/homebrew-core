class SeleniumServer < Formula
  desc "Browser automation for testing purposes"
  homepage "https://www.selenium.dev/"
  url "https://github.com/SeleniumHQ/selenium/releases/download/selenium-4.14.0/selenium-server-4.14.1.jar"
  sha256 "dcf01b3109fefaab5cfa42bce545f1745421d7ce514083f6b2b327bbbaee54eb"
  license "Apache-2.0"

  livecheck do
    url "https://www.selenium.dev/downloads/"
    regex(/href=.*?selenium-server[._-]v?(\d+(?:\.\d+)+)\.jar/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ee6442e94e5df3fcca4e552d02faadea740bec3f5c23c3ecb477229c312041d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee6442e94e5df3fcca4e552d02faadea740bec3f5c23c3ecb477229c312041d3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee6442e94e5df3fcca4e552d02faadea740bec3f5c23c3ecb477229c312041d3"
    sha256 cellar: :any_skip_relocation, sonoma:         "ee6442e94e5df3fcca4e552d02faadea740bec3f5c23c3ecb477229c312041d3"
    sha256 cellar: :any_skip_relocation, ventura:        "ee6442e94e5df3fcca4e552d02faadea740bec3f5c23c3ecb477229c312041d3"
    sha256 cellar: :any_skip_relocation, monterey:       "ee6442e94e5df3fcca4e552d02faadea740bec3f5c23c3ecb477229c312041d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12e3a418127d8afb7983cba58b66f7712941ad2e73a622f0f65f32263e4bf9b0"
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
