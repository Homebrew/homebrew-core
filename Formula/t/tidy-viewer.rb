class TidyViewer < Formula
  desc "CLI csv pretty printer"
  homepage "https://github.com/alexhallam/tv"
  url "https://github.com/alexhallam/tv/archive/refs/tags/1.8.93.tar.gz"
  sha256 "e99811843fe3e28d22c82f6c8ad757bf5065c622fbbb2d7e4011ab346dca6f1d"
  license "Unlicense"

  # Some tagged versions using a stable version format are marked as
  # "pre-release" on GitHub, so it's necessary to check releases.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7673c3682c0550e667dbf4a64e46262bfa5952a8f6d2cda5de6016f2abce527e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59e5edc1187a4fddb10592384f491b0199410c3d0cd9876a50e31e1cfed74139"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63a15fd1cf49c717544e9c4d67d225032c96e335487e91f61a280220ae277214"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a9234b7369f9fb91d430b4f109108129349e9c577ecee6225c3919cba256f08d"
    sha256 cellar: :any_skip_relocation, sonoma:        "7063ec566328d464dbf16495cb34b804cae5bd69a3022fe707e68f8a3b3a94c0"
    sha256 cellar: :any_skip_relocation, ventura:       "cc554f92a73722ed202bca0a40da4998726c4909acfcd1833fa86b3df146adf6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3e4c1abf58e2202e189964db71b04df20fc4f42b1d9c4ba26499057328165da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe2877bb0b8093eb42716de3339a76afe78a6f2f83bc98540e6f8aecbda4af73"
  end

  depends_on "rust" => :build

  conflicts_with "television", because: "both install `tv` binaries"

  def install
    system "cargo", "install", *std_cargo_args(path: "tidy-viewer-cli")
    bin.install_symlink "tidy-viewer" => "tv"
  end

  test do
    (testpath/"test.csv").write("first header,second header")
    assert_match "first header", shell_output("#{bin}/tv #{testpath}/test.csv")
  end
end
