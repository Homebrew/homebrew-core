class SpringLoaded < Formula
  desc "Java agent to enable class reloading in a running JVM"
  homepage "https://github.com/spring-projects/spring-loaded"
  url "https://search.maven.org/remotecontent?filepath=org/springframework/springloaded/1.2.6.RELEASE/springloaded-1.2.6.RELEASE.jar"
  version "1.2.6"
  sha256 "6edd6ffb3fd82c3eee95f5588465f1ab3a94fc5fff65b6e3a262f6de5323d203"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf07fe442b529bea88c9a3e8b0476184179150c03c2a5751c0d8ac98911ef2ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf07fe442b529bea88c9a3e8b0476184179150c03c2a5751c0d8ac98911ef2ee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cf07fe442b529bea88c9a3e8b0476184179150c03c2a5751c0d8ac98911ef2ee"
    sha256 cellar: :any_skip_relocation, ventura:        "cf07fe442b529bea88c9a3e8b0476184179150c03c2a5751c0d8ac98911ef2ee"
    sha256 cellar: :any_skip_relocation, monterey:       "cf07fe442b529bea88c9a3e8b0476184179150c03c2a5751c0d8ac98911ef2ee"
    sha256 cellar: :any_skip_relocation, big_sur:        "cf07fe442b529bea88c9a3e8b0476184179150c03c2a5751c0d8ac98911ef2ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eabd6199b0de8ccd7824ae2ccb41e60197c431ba028bae644a2661d6732f3b41"
  end

  depends_on "openjdk" => :test

  def install
    (share/"java").install "springloaded-#{version}.RELEASE.jar" => "springloaded.jar"
  end

  test do
    system "#{Formula["openjdk"].bin}/java", "-javaagent:#{share}/java/springloaded.jar", "-version"
  end
end
