class SonarBuildWrapper < Formula
  desc "Build Wrapper for SonarQube C/C++ and Objective-C plugins"
  homepage "http://docs.sonarqube.org/pages/viewpage.action?pageId=3080359"
  url "https://sonarqube.com/static/cpp/build-wrapper-macosx-x86.zip"
  version "4.1"
  sha256 "5b6dc15d2e85edf5cd24e932e390e94cd1a6e472a07d2bef4dc9c04e696d0348"

  bottle :unneeded

  def install
    bin.install "build-wrapper-macosx-x86"
    lib.install "libinterceptor.dylib"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/build-wrapper-macosx-x86 -h", 10)
  end
end
