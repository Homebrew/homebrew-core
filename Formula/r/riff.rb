class Riff < Formula
  desc "Diff filter highlighting which line parts have changed"
  homepage "https://github.com/walles/riff"
  url "https://github.com/walles/riff/archive/refs/tags/3.7.0.tar.gz"
  sha256 "996d3037788c971fde859720557a04b6910e68b887e058df037a868fddad726b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "853348c2031c575f6189ced9c191b243797955b20cf29f44b55067af36f439ba"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b2e467965919a0cdfebd2600c0ff6c5507ab5e3d99d7408da7cef4c37011a10b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "29ddaf39b1b87b8ef2352419ca9392ccb76ceec3ba8722a6a53d879d51ff0471"
    sha256 cellar: :any,                 arm64_linux:       "88294019a7a93f65b20d70c50005ba963c34a73bde073b506fba73986fc28b12"
    sha256 cellar: :any,                 x86_64_linux:      "08483d18a2f4a45843fd241037d378bb33eb4c2211b993d4b834d1c44b095c1e"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_empty shell_output("#{bin}/riff /etc/passwd /etc/passwd")
    assert_match version.to_s, shell_output("#{bin}/riff --version")
  end
end
