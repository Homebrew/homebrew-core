class XCmd < Formula
  desc "Bootstrap 1000+ command-line tools in seconds"
  homepage "https://x-cmd.com"
  url "https://github.com/x-cmd/x-cmd/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "5a2bdc913e6ae35003a5d41dd359de3cdf6c5efb9f0fb0af299ba1b1360341b7"
  license all_of: ["AGPL-3.0-only", "MIT", "BSD-3-Clause"]

  head "https://github.com/x-cmd/x-cmd.git", branch: "X"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a83fa0924aa6c2caf672a72ef5d4fd78272de7dcbffe0748493e7e399b7a7fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a83fa0924aa6c2caf672a72ef5d4fd78272de7dcbffe0748493e7e399b7a7fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4a83fa0924aa6c2caf672a72ef5d4fd78272de7dcbffe0748493e7e399b7a7fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "91f8e90821e57369abe776b80724d39e519682b083d8b1c7c3a21114317cd749"
    sha256 cellar: :any_skip_relocation, ventura:       "91f8e90821e57369abe776b80724d39e519682b083d8b1c7c3a21114317cd749"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79dbd45b076afa90b12640b77a18a0a647bdf5e1f838a9451940c053306b0b17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79dbd45b076afa90b12640b77a18a0a647bdf5e1f838a9451940c053306b0b17"
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
