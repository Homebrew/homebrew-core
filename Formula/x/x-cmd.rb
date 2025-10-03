class XCmd < Formula
  desc "Bootstrap 1000+ command-line tools in seconds"
  homepage "https://x-cmd.com"
  url "https://github.com/x-cmd/x-cmd/archive/refs/tags/v0.6.14.tar.gz"
  sha256 "869a3ac8fe6a62595c91502296b662ff4c86d6e053d17fa495969b2d4f1ea665"
  license all_of: ["AGPL-3.0-only", "MIT", "BSD-3-Clause"]

  head "https://github.com/x-cmd/x-cmd.git", branch: "X"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f0ae7fa80808f9884cb00d6cc9028f12dbfbf563bf4ad3a4a7b16e4055843d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f0ae7fa80808f9884cb00d6cc9028f12dbfbf563bf4ad3a4a7b16e4055843d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f0ae7fa80808f9884cb00d6cc9028f12dbfbf563bf4ad3a4a7b16e4055843d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "659c89b1fb5a008abc29c53cfaa43f53a9236b10a356fb7d410ec5f7ca9866f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb6bc32547764b8e5128d1771b237bdd952380dabe37ee6c6bc00177fa25223c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb6bc32547764b8e5128d1771b237bdd952380dabe37ee6c6bc00177fa25223c"
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
