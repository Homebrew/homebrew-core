class Sc < Formula
  desc "Sauce Connect(TM) is a proxy server that opens a secure connection between a Sauce Labs virtual machine running your browser tests, and an application or website you want to test that's on your local machine or behind a corporate firewall."
  homepage "https://wiki.saucelabs.com/display/DOCS/Sauce+Connect+Proxy"
  url "https://saucelabs.com/downloads/sc-4.4.9-osx.zip"
  sha256 "c88731ffe03c1f0c7ff98e0036a467ea5bce1ff757b27b31c85d6e6e219cdfc5"

  def install
    ohai "By installing this formula, you agree to the license.html file included with the installation"
    ohai "See: #{doc}/license.html"
    bin.install Dir["#{buildpath}/bin/sc"]
    doc.install "license.html"
  end

  test do
    output = pipe_output("#{bin}/sc")
    assert_no_match /.*No such file or directory.*/, output
    assert_no_match /.*command not found.*/, output
    assert_match /.*Error, no user specified..*/, output
    output = pipe_output("#{bin}/sc --version")
    assert_match /.*Sauce Connect.*/, output
    output = pipe_output("#{bin}/sc --help")
    assert_match /.*Show usage information.*/, output
  end
end
