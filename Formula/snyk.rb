class Snyk < Formula
  desc "CLI and build-time tool to find & fix known vulnerabilities in open-source dependencies"
  homepage "https://snyk.io"
  url "https://github.com/snyk/snyk/releases/download/v1.136.1/snyk-macos"
  sha256 "536f87ce96db856ec49f8cea9e2bbe66492d9799085743b511f9f86b6f76430d"

  bottle :unneeded

  depends_on :arch => :x86_64

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/snyk"
  end

  test do
    system bin/"snyk", "version"
  end
end

