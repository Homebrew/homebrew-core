class UnisonLocalUi < Formula
  desc "Unison Language and Codebase Manager"
  homepage "https://unisonweb.org"
  url "https://github.com/unisonweb/unison-local-ui/archive/refs/tags/release/0.5.16.tar.gz"
  sha256 "0cde308faf5d47ebf4910e5b4a0f6276fcafc78cce5014a905a85d7c6f9d557c"
  license "MIT"

  depends_on "node" => :build

  def install
    system "npm", "ci"
    system "npm", "run", "ui-core-install"
    system "softwareupdate", "--agree-to-license", "--install-rosetta" if Hardware::CPU.arm? && OS.mac?
    system "npm", "run", "build"
    (pkgshare/"ui").install Dir["dist/unisonLocal/*"]
  end

  test do
    system "find", prefix
    system "find", opt_prefix
    assert_predicate pkgshare/"ui"/"index.html", :exist?
  end
end
