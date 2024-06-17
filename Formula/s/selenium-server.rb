class SeleniumServer < Formula
  desc "Browser automation for testing purposes"
  homepage "https://www.selenium.dev/"
  url "https://github.com/SeleniumHQ/selenium/releases/download/selenium-4.21.0/selenium-server-4.21.0.jar"
  sha256 "c7cf00ac68c19c4ccca5869dedc0c800d59fc966313ad39b2f01f7823cccb4e6"
  license "Apache-2.0"

  livecheck do
    url "https://www.selenium.dev/downloads/"
    regex(/href=.*?selenium-server[._-]v?(\d+(?:\.\d+)+)\.jar/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a19ed75643e619ba2a957e96d05920bc69a1e538bf7e4eec1e3caf30918048e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f0fd80bfc511a5b0e3226d0c1bfeef3bd9351bcf92765717d8af7ee585e146d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5452d18797e1f33cf3def44c009337ad5753d09ec39de86bdbf58cc08011ad24"
    sha256 cellar: :any_skip_relocation, sonoma:         "903d3affa5c0be12ff2de5ebae8d427cdd4ebb1b800ee4df0e96e43d24b94a34"
    sha256 cellar: :any_skip_relocation, ventura:        "1f8347194a58084d627a315bd21a89daf490caf8ee15109bdc83aaf71d77dfd7"
    sha256 cellar: :any_skip_relocation, monterey:       "a018dceb35fb0aac9281e3f93d03485ea11d9f24c5c5f1c59c5dd1cf249ec7d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d42df5a49d895f4f3b4c46fb38baf6a72a7eedd390fd725ba808d9c2e967562"
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
