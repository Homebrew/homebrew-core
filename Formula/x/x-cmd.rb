class XCmd < Formula
  desc "Bootstrap 1000+ command-line tools in seconds"
  homepage "https://x-cmd.com"
  url "https://github.com/x-cmd/x-cmd/archive/refs/tags/v0.9.8.tar.gz"
  sha256 "7b4f183e89033ecba5070ac1786f4f692f3cf3e0173f16cf859b36236c83c3e9"
  license all_of: ["Apache-2.0", "MIT", "BSD-3-Clause"]
  head "https://github.com/x-cmd/x-cmd.git", branch: "X"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e7e8a43127c2d5723b8173ac22c12a55dd532239ec58eaa902c7eb38f19dee5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e7e8a43127c2d5723b8173ac22c12a55dd532239ec58eaa902c7eb38f19dee5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e7e8a43127c2d5723b8173ac22c12a55dd532239ec58eaa902c7eb38f19dee5"
    sha256 cellar: :any_skip_relocation, sonoma:        "c0c4d1c5a5275678966fc5b7f3180069002b99bbb614fc340ac5d1a968914b13"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1d27e68db62c846a3b66ce54ad49a2d062ac2151b0b54a06745458c13f10065"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1d27e68db62c846a3b66ce54ad49a2d062ac2151b0b54a06745458c13f10065"
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
