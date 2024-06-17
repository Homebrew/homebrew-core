class WiremockStandalone < Formula
  desc "Simulator for HTTP-based APIs"
  homepage "https://wiremock.org/docs/running-standalone/"
  url "https://search.maven.org/remotecontent?filepath=org/wiremock/wiremock-standalone/3.6.0/wiremock-standalone-3.6.0.jar"
  sha256 "b4b3a21a5e7f1ee0db86b472bbec59ea52f8d3c9fce4c5e5eb795e70682893dc"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/wiremock/wiremock-standalone/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "92f2dba92bde2904c1ef58b0902922bf3e5a9fb84706439c6ba1b00799304c7b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "19453b2b733ad5c41bea7f20fb9142c25a0f494f6d321f8d2bc5a233808a12cb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5916812ccb31d5b1e9b99b7d3cefc282fc8859a1bb47753d1062d962908555e9"
    sha256 cellar: :any_skip_relocation, sonoma:         "cd187746369852b12425b577ea1bf4686568b5d4c63bdcf20d7c89a7cae72ab9"
    sha256 cellar: :any_skip_relocation, ventura:        "4d9bdc5db2630ef905426bc6d7a2cc002a5ef07ec5efd730645dc8dd0ebe17f2"
    sha256 cellar: :any_skip_relocation, monterey:       "e90ed78d0895ea065fafbe9ee5e82bae27ebd5114205037770c6490ce59b7315"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13519c4ba891c2a04d356039d8bc1a1d8782458be98e4b374313b5b3c34613bc"
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
