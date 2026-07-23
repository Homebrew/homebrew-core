class Urlfinder < Formula
  desc "Extracting URLs and subdomains from JS files on a website"
  homepage "https://github.com/pingc0y/URLFinder"
  url "https://github.com/pingc0y/URLFinder/archive/refs/tags/2026.6.16.tar.gz"
  sha256 "12041f7a02fa0f8dbe502d838fb3c5e4c84def44c1bf18efb39e4fdb096f464a"
  license "MIT"
  head "https://github.com/pingc0y/URLFinder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e090b38146d744327eaa9f3920c4f19d73f8a8850944a2d2c1ceff4207de8442"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e090b38146d744327eaa9f3920c4f19d73f8a8850944a2d2c1ceff4207de8442"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e090b38146d744327eaa9f3920c4f19d73f8a8850944a2d2c1ceff4207de8442"
    sha256 cellar: :any_skip_relocation, sonoma:        "9cf8a4338d2bd56a5a599ecf7c127e9f1a2bcbb21ebd5d41d819de3832b5ecf6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "938e1d36c376a9f22d844c8049a1d28a72079f69a8fac7ee5bdbb6907ed37a2b"
    sha256 cellar: :any,                 x86_64_linux:  "a0bd44cee95f05f2080fe7ec0a24c6d7f7591a6dd2ea6424ba5ea6a593670924"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "Start 1 Spider...", shell_output("#{bin}/urlfinder -u https://example.com")
    assert_match version.to_s, shell_output("#{bin}/urlfinder version")
  end
end
