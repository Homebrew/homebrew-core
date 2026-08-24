class XCmd < Formula
  desc "Bootstrap 1000+ command-line tools in seconds"
  homepage "https://x-cmd.com"
  url "https://github.com/x-cmd/x-cmd/archive/refs/tags/v0.10.5.tar.gz"
  sha256 "d93c81e395a85062c445265ce308b8d5ec85f0da9eec0f8f2b860df1fdae9784"
  license all_of: ["Apache-2.0", "MIT", "BSD-3-Clause"]
  head "https://github.com/x-cmd/x-cmd.git", branch: "X"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b8700d603bb6e84a590fa15cc8fbc375e41c78b492ea9cf617f0c8a198303a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b8700d603bb6e84a590fa15cc8fbc375e41c78b492ea9cf617f0c8a198303a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b8700d603bb6e84a590fa15cc8fbc375e41c78b492ea9cf617f0c8a198303a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "2274b6378b3e5934ed6663cdb01ec1e3e751a3a243d295ebd5747c8c153cc1b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d383ce5baf04097d9341ca53dc950be7c4a9bd2d19ad4523ce29ff5599b3b1a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d383ce5baf04097d9341ca53dc950be7c4a9bd2d19ad4523ce29ff5599b3b1a4"
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
