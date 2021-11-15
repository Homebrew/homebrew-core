class SeleniumServer < Formula
  desc "Browser automation for testing purposes"
  homepage "https://www.selenium.dev/"
  url "https://github.com/SeleniumHQ/selenium/releases/download/selenium-4.0.0/selenium-server-4.0.0.jar"
  sha256 "0e381d119e59c511c62cfd350e79e4150df5e29ff6164dde03631e60072261a5"
  license "Apache-2.0"

  livecheck do
    url "https://www.selenium.dev/downloads/"
    regex(/href=.*?selenium-server[._-]v?(\d+(?:\.\d+)+)\.jar/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "edfff3c2a862fc73572c50059c9cda65c52a5e6e53ba36e84b5eccd97c2a5843"
    sha256 cellar: :any_skip_relocation, big_sur:       "edfff3c2a862fc73572c50059c9cda65c52a5e6e53ba36e84b5eccd97c2a5843"
    sha256 cellar: :any_skip_relocation, catalina:      "edfff3c2a862fc73572c50059c9cda65c52a5e6e53ba36e84b5eccd97c2a5843"
    sha256 cellar: :any_skip_relocation, mojave:        "edfff3c2a862fc73572c50059c9cda65c52a5e6e53ba36e84b5eccd97c2a5843"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99b75acd589404b60ec859ad259bf1f6ab363db9505c21ad62c826216a37375a"
    sha256 cellar: :any_skip_relocation, all:           "928c2af17b84c75a4ab6ff97a7b23b4217db1ccdd7e5dfd839e4d945cf199e77"
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
