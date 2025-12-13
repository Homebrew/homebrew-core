class Rv < Formula
  desc "Ruby version manager"
  homepage "https://github.com/spinel-coop/rv"
  url "https://github.com/spinel-coop/rv/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "3fe6617b49cba218ae6133f1bdf64008bac88ddbf94c13d24014716ea65012fc"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/spinel-coop/rv.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "14394352ae5c65a041f36ee617235e394033805a33000e7260d794f101f87523"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fbee92e6a0834f12e6286ca2f35b35aa3a4681dafd22c284147061cf94d78da3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "773ac5241967d429db677c1cb36bf7346603ef1620e6f3e65a60c678bcff629b"
    sha256 cellar: :any_skip_relocation, sonoma:        "729a2a3b54be62f3f17428872c4fdb508822aea80374a179c5e4816731c92007"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b969f0f49262ad22a506f104486d6438222ce1e5b534d586359b21348e91a3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08441d39160ee98939516df3cc6840f65b89746d00b1c33e35528d7f0ac963e9"
  end

  depends_on "rust" => :build
  depends_on macos: :sonoma

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/rv")
    generate_completions_from_executable(bin/"rv", "shell", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rv --version")
    assert_match "No Ruby installations found.", shell_output("#{bin}/rv ruby list --installed-only 2>&1")
    assert_match "Homebrew", shell_output("#{bin}/rv ruby run 3.4.5 -- -e 'puts \"Homebrew\"'")
  end
end
