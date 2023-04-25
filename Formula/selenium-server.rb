class SeleniumServer < Formula
  desc "Browser automation for testing purposes"
  homepage "https://www.selenium.dev/"
  url "https://github.com/SeleniumHQ/selenium/releases/download/selenium-4.9.0/selenium-server-4.9.0.jar"
  sha256 "888dc65891cc634a8d60fbdb29da4124fbf1464adc2b05cd8bd00f82aa9eff60"
  license "Apache-2.0"

  livecheck do
    url "https://www.selenium.dev/downloads/"
    regex(/href=.*?selenium-server[._-]v?(\d+(?:\.\d+)+)\.jar/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ecfaa86792c7d6c0b63b6589d1ca76b7bc05e8a0613b7f9ef3242de4e583364"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ecfaa86792c7d6c0b63b6589d1ca76b7bc05e8a0613b7f9ef3242de4e583364"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7ecfaa86792c7d6c0b63b6589d1ca76b7bc05e8a0613b7f9ef3242de4e583364"
    sha256 cellar: :any_skip_relocation, ventura:        "7ecfaa86792c7d6c0b63b6589d1ca76b7bc05e8a0613b7f9ef3242de4e583364"
    sha256 cellar: :any_skip_relocation, monterey:       "7ecfaa86792c7d6c0b63b6589d1ca76b7bc05e8a0613b7f9ef3242de4e583364"
    sha256 cellar: :any_skip_relocation, big_sur:        "7ecfaa86792c7d6c0b63b6589d1ca76b7bc05e8a0613b7f9ef3242de4e583364"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74aba8f38c064d8dbc593a326c72d310f011459f9c7d37eaeecbeb1536490961"
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
    sleep 20
    output = shell_output("curl --silent localhost:#{port}/status")
    output = JSON.parse(output)

    assert_equal true, output["value"]["ready"]
    assert_match version.to_s, output["value"]["nodes"].first["version"]
  end
end
