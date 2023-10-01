class WiremockStandalone < Formula
  desc "Simulator for HTTP-based APIs"
  homepage "https://wiremock.org/docs/running-standalone/"
  url "https://search.maven.org/remotecontent?filepath=org/wiremock/wiremock-standalone/3.1.0/wiremock-standalone-3.1.0.jar"
  sha256 "4b220d90733f3eb27cf24101eb6519d3ad00bdc4750e319463b7dbac9973a3f7"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/wiremock/wiremock-standalone/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0c642ef364fefdc76482d5f66ec06da8c00e8186f9fc772911a60d7fd0ba5a7b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0c642ef364fefdc76482d5f66ec06da8c00e8186f9fc772911a60d7fd0ba5a7b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c642ef364fefdc76482d5f66ec06da8c00e8186f9fc772911a60d7fd0ba5a7b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0c642ef364fefdc76482d5f66ec06da8c00e8186f9fc772911a60d7fd0ba5a7b"
    sha256 cellar: :any_skip_relocation, sonoma:         "0c642ef364fefdc76482d5f66ec06da8c00e8186f9fc772911a60d7fd0ba5a7b"
    sha256 cellar: :any_skip_relocation, ventura:        "0c642ef364fefdc76482d5f66ec06da8c00e8186f9fc772911a60d7fd0ba5a7b"
    sha256 cellar: :any_skip_relocation, monterey:       "0c642ef364fefdc76482d5f66ec06da8c00e8186f9fc772911a60d7fd0ba5a7b"
    sha256 cellar: :any_skip_relocation, big_sur:        "0c642ef364fefdc76482d5f66ec06da8c00e8186f9fc772911a60d7fd0ba5a7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f088f12405212925a9a3fca4e043206e0cc608b85ea1c139d5dd7b6dc28299e"
  end

  depends_on "openjdk"

  def install
    libexec.install "wiremock-standalone-#{version}.jar"
    bin.write_jar_script libexec/"wiremock-standalone-#{version}.jar", "wiremock"
  end

  test do
    port = free_port

    wiremock = fork do
      exec "#{bin}/wiremock", "-port", port.to_s
    end

    loop do
      Utils.popen_read("curl", "-s", "http://localhost:#{port}/__admin/", "-X", "GET")
      break if $CHILD_STATUS.exitstatus.zero?
    end

    system "curl", "-s", "http://localhost:#{port}/__admin/shutdown", "-X", "POST"

    Process.wait(wiremock)
  end
end
