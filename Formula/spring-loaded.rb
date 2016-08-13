class SpringLoaded < Formula
  desc "Java agent to enable class reloading in a running JVM"
  homepage "https://github.com/spring-projects/spring-loaded"
  url "https://repo.spring.io/simple/libs-release-local/org/springframework/springloaded/1.2.6.RELEASE/springloaded-1.2.6.RELEASE.jar"
  version "1.2.6"
  sha256 "6edd6ffb3fd82c3eee95f5588465f1ab3a94fc5fff65b6e3a262f6de5323d203"

  bottle :unneeded

  def install
    (share/"java").install "springloaded-#{version}.RELEASE.jar" => "springloaded.jar"
  end

  test do
    system "java", "-javaagent:#{share}/java/springloaded.jar", "-version"
  end
end
