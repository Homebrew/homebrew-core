# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Quarantinecli < Formula
  desc "A CLI Utility to quarantine, dequarantine, and look at the status of quarantined files on macOS"
  homepage "https://github.com/Serena-io/quarantineCLI"
  url "https://github.com/Serena-io/quarantineCLI/archive/refs/tags/1.0.0.tar.gz"
  version "1.0.0"
  sha256 "69ab41c71ed37c5b47e7dc5ed54bde28f15eaf38c81d804f768f74fb482a28e6"
  license "MIT"

  depends_on :xcode => "12.3"
  depends_on :macos

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/quarantinecli"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test quarantinecli`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "touch foo"
    system "${bin}/quarantinecli --status foo"
  end
end
