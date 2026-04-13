class XCmd < Formula
  desc "Bootstrap 1000+ command-line tools in seconds"
  homepage "https://x-cmd.com"
  url "https://github.com/x-cmd/x-cmd/archive/refs/tags/v0.8.13.tar.gz"
  sha256 "7c5dd5c3e7f8594954d1b71afa19614db218bc89398f562697e62e6678903755"
  license all_of: ["Apache-2.0", "MIT", "BSD-3-Clause"]
  head "https://github.com/x-cmd/x-cmd.git", branch: "X"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b8acbaa6fc8d55ca9383bafc5fd15f2bb1cfe7ecbc5ab6367a1695f04563e6ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8acbaa6fc8d55ca9383bafc5fd15f2bb1cfe7ecbc5ab6367a1695f04563e6ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8acbaa6fc8d55ca9383bafc5fd15f2bb1cfe7ecbc5ab6367a1695f04563e6ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "39e1c69676c1d770fa8937d5f0366347ff4de4b16a17db539bf2a4ae8bf00ddc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "052b202ddb083d8b6449bcb09a01e7570429436313f3c6ede7889f5871bd30b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "052b202ddb083d8b6449bcb09a01e7570429436313f3c6ede7889f5871bd30b5"
  end

  def install
    prefix.install Dir.glob("*")
    prefix.install Dir.glob(".x-cmd")
    inreplace prefix/"mod/x-cmd/lib/bin/x-cmd", "/opt/homebrew/Cellar/x-cmd/latest", prefix.to_s
    bin.install prefix/"mod/x-cmd/lib/bin/x-cmd"
  end

  test do
    assert_match "Welcome to x-cmd", shell_output("#{bin}/x-cmd 2>&1")
    assert_match "hello", shell_output("#{bin}/x-cmd cowsay hello")
  end
end
