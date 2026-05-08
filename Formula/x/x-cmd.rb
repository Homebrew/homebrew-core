class XCmd < Formula
  desc "Bootstrap 1000+ command-line tools in seconds"
  homepage "https://x-cmd.com"
  url "https://github.com/x-cmd/x-cmd/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "c2451311696cdbf0697d3db359073ae317a886f62f0b238325e78eaf2cae33ea"
  license all_of: ["Apache-2.0", "MIT", "BSD-3-Clause"]
  head "https://github.com/x-cmd/x-cmd.git", branch: "X"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6766d681a58d80af09e480f4da38d9a81acd78c346a53eb2ec8ad8da7781b818"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6766d681a58d80af09e480f4da38d9a81acd78c346a53eb2ec8ad8da7781b818"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6766d681a58d80af09e480f4da38d9a81acd78c346a53eb2ec8ad8da7781b818"
    sha256 cellar: :any_skip_relocation, sonoma:        "107139e9769f03463058d19bb6b51bb3f011f30b7ad0e7140b961d60bc08a716"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f070c2b336aad2fd3c1d89065076e8982c96e6183ade8b18d209d1764377fe80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f070c2b336aad2fd3c1d89065076e8982c96e6183ade8b18d209d1764377fe80"
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
