class WiremockStandalone < Formula
  desc "Simulator for HTTP-based APIs"
  homepage "https://wiremock.org/docs/running-standalone/"
  url "https://search.maven.org/remotecontent?filepath=org/wiremock/wiremock-standalone/3.9.1/wiremock-standalone-3.9.1.jar"
  sha256 "723a880d50d3b0a145af0df07e578c2cb85e77feb2231e6991c9a1366926912c"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/wiremock/wiremock-standalone/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e330f5c5245c8709b79ea5cad3c2fe28e5ff2e320e0523e8f778b7bc6a53dae7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d5416c1558773bd367f63bd53da82c5a2eefe036ff5dd4eacba3ded16e72ed9c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5416c1558773bd367f63bd53da82c5a2eefe036ff5dd4eacba3ded16e72ed9c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5416c1558773bd367f63bd53da82c5a2eefe036ff5dd4eacba3ded16e72ed9c"
    sha256 cellar: :any_skip_relocation, sonoma:         "03c77240f3159ffa6ef169e6610f5a4bd529bba8e4ab30c6f492fbdd17501caa"
    sha256 cellar: :any_skip_relocation, ventura:        "03c77240f3159ffa6ef169e6610f5a4bd529bba8e4ab30c6f492fbdd17501caa"
    sha256 cellar: :any_skip_relocation, monterey:       "d5416c1558773bd367f63bd53da82c5a2eefe036ff5dd4eacba3ded16e72ed9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "befea5a111b1c8ad2f4ec4e0dbfa62992d82da8249b71a72b0d20cda848da77b"
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
