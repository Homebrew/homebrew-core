class SeleniumServer < Formula
  desc "Browser automation for testing purposes"
  homepage "https://www.selenium.dev/"
  url "https://github.com/SeleniumHQ/selenium/releases/download/selenium-4.8.0/selenium-server-4.8.0.jar"
  sha256 "40cac342e1f4cff53cb7e05d7556937797f4a41b133f22990f7e579359345d1b"
  license "Apache-2.0"

  livecheck do
    url "https://www.selenium.dev/downloads/"
    regex(/href=.*?selenium-server[._-]v?(\d+(?:\.\d+)+)\.jar/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa18cfc075854d878fca7c8b428b4e8703e7907f1b91808d9ee7382bfb5ae387"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa18cfc075854d878fca7c8b428b4e8703e7907f1b91808d9ee7382bfb5ae387"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fa18cfc075854d878fca7c8b428b4e8703e7907f1b91808d9ee7382bfb5ae387"
    sha256 cellar: :any_skip_relocation, ventura:        "fa18cfc075854d878fca7c8b428b4e8703e7907f1b91808d9ee7382bfb5ae387"
    sha256 cellar: :any_skip_relocation, monterey:       "fa18cfc075854d878fca7c8b428b4e8703e7907f1b91808d9ee7382bfb5ae387"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa18cfc075854d878fca7c8b428b4e8703e7907f1b91808d9ee7382bfb5ae387"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20421b38f8fdde48e27285d6d9ac7cdaf56b179495c840098bc1eef063e48108"
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
