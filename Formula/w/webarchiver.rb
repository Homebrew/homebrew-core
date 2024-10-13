class Webarchiver < Formula
  desc "Allows you to create Safari .webarchive files"
  homepage "https://github.com/newzealandpaul/webarchiver"
  url "https://github.com/newzealandpaul/webarchiver/archive/refs/tags/0.12.tar.gz"
  sha256 "bb21767a506841a41ca4ea44d78c6f3012e61ca327df620a7c312759e4b5866d"
  license "GPL-3.0-only"
  head "https://github.com/newzealandpaul/webarchiver.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "aa8c893575f148bef6467f55687ff76fac39e94d6eaa986581067b04ed82b820"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2f3dc0703cd368465c5d1a3a743b508240110c108ed452c218f8ffd4d599d4f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "632a2f4f2d37e7d78c3bd62fc3cdec52ca18fcd17c9418f4def7d02bd4932ff4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f24ef245a401c0db49bec83e169f53c38d677623bb7ca850bf0ccc373403e1dc"
    sha256 cellar: :any_skip_relocation, sonoma:         "19c7e2b3506b603f68603267dafc9d0aac8be049cd134a16cf8dbb0dfc5b5813"
    sha256 cellar: :any_skip_relocation, ventura:        "86467f1cb67c377e7ed6c9721e85219feab3681567000759808994c8c7653a96"
    sha256 cellar: :any_skip_relocation, monterey:       "bef93d5067f0fb1c3bbd5d716c952ae9b2ae7a1dd1c524b7627637979b8b3289"
  end

  depends_on xcode: ["6.0.1", :build]
  depends_on :macos

  def install
    # Force 64 bit-only build, otherwise it fails on Mojave
    xcodebuild "SYMROOT=build", "-arch", Hardware::CPU.arch

    bin.install "./build/Release/webarchiver"
  end

  test do
    system bin/"webarchiver", "-url", "https://www.google.com", "-output", "foo.webarchive"
    assert_match "Apple binary property list", shell_output("file foo.webarchive")
  end
end
