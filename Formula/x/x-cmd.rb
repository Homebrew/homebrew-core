class XCmd < Formula
  desc "Bootstrap 1000+ command-line tools in seconds"
  homepage "https://x-cmd.com"
  url "https://github.com/x-cmd/x-cmd/archive/refs/tags/v0.8.3.tar.gz"
  sha256 "1c4faedd3dc95a643859e56cfe885f86e8189107995ab0b1eb2a64c433f95965"
  license all_of: ["Apache-2.0", "MIT", "BSD-3-Clause"]
  head "https://github.com/x-cmd/x-cmd.git", branch: "X"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "882b7e107bceb8e07d96ed2a277df1770fc268f350ddf892dfdc52f959fdeb01"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "882b7e107bceb8e07d96ed2a277df1770fc268f350ddf892dfdc52f959fdeb01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "882b7e107bceb8e07d96ed2a277df1770fc268f350ddf892dfdc52f959fdeb01"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f30591f1bc70562022ebed67383cbbd83a907c52e68180e4ba8d49830197585"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2e4d89e83068fe95f9fc89dc4a052f8abefd332ef615333a659706360b86181"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2e4d89e83068fe95f9fc89dc4a052f8abefd332ef615333a659706360b86181"
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
