class Zeptoclaw < Formula
  desc "Lightweight personal AI gateway with layered safety controls"
  homepage "https://zeptoclaw.com/"
  url "https://github.com/qhkm/zeptoclaw/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "4efdaa4a9addaa7f3835d95d8bb45bf76baf0e6c1a05d9bf35243a0811b3671e"
  license "Apache-2.0"
  head "https://github.com/qhkm/zeptoclaw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac661bfe14898222fe5fa7b2e551b03958927cdcac1cef7b1fc57e2ddd9ae0fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21cd172f66055b36be3a4db8a247bc8edd6db267c060c30564b7b1d2047becb1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4cf0dc1c5c85b9127ab6b2df4ec6e8dbf75d260616372500734d9e833ad8cd9"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4cb2ec706eb914084a89db63fbda555d13ba886c5294f984d21b2d2dde8ca9a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dbb2de27fc86e090e2f7efed9adfbc1220ef791981ee5739a52dd48197b5238a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf75b3b1b6c3ac343b28251e4a1b171a041b1dfd2ef3c5a030e6d86e748a83c5"
  end

  depends_on "rust" => :build

  def install
    # upstream bug report on the build target issue, https://github.com/qhkm/zeptoclaw/issues/119
    system "cargo", "install", "--bin", "zeptoclaw", *std_cargo_args
  end

  service do
    run [opt_bin/"zeptoclaw", "gateway"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zeptoclaw --version")
    assert_match "No config file found", shell_output("#{bin}/zeptoclaw config check")
  end
end
