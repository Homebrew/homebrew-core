class SpringLoaded < Formula
  desc "Java agent to enable class reloading in a running JVM"
  homepage "https://github.com/spring-projects/spring-loaded"
  url "https://repo.spring.io/simple/libs-release-local/org/springframework/springloaded/1.2.6.RELEASE/springloaded-1.2.6.RELEASE.jar"
  version "1.2.6"
  sha256 "6edd6ffb3fd82c3eee95f5588465f1ab3a94fc5fff65b6e3a262f6de5323d203"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8889674afb0c259e57a517ab84bd56305b39e42b92f09d3ce556a03e68b9ead2"
  end

  depends_on "openjdk" => :test

  def install
    (share/"java").install "springloaded-#{version}.RELEASE.jar" => "springloaded.jar"
  end

  test do
    system "#{Formula["openjdk"].bin}/java", "-javaagent:#{share}/java/springloaded.jar", "-version"
  end
end
