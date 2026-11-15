class Serpl < Formula
  desc "Simple terminal UI for search and replace"
  homepage "https://github.com/yassinebridi/serpl"
  url "https://github.com/yassinebridi/serpl/archive/refs/tags/0.3.11.tar.gz"
  sha256 "e28cdbffd92640bf73486a13c0b36406514811694bf721d3ab7f459c107ae439"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d485b8e8070a4fc09c6dd4e7bd324d14c1125e63a0b28f39ea64ab24dbccb540"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0c9b2160d6f3d0e52d674e1103dc93d2f261099e5658f9feb5f70eb2b08433bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ee009b7ae3a243a7aa231e25fc848afe7ee97433a717b6e0bab655317e5b5eee"
    sha256 cellar: :any,                 arm64_linux:       "7441c287dffb7f53ed8260fbc62854cd447f91bf0ec7ea131c618447e91dff77"
    sha256 cellar: :any,                 x86_64_linux:      "b56420c7c75843d887db4308c78e6d3ebdcb5f94f88508499d62490e48a6d30e"
  end

  depends_on "rust" => :build
  depends_on "ripgrep"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/serpl --version")

    assert_match "a value is required for '--project-root <PATH>' but none was supplied",
      shell_output("#{bin}/serpl --project-root 2>&1", 2)
  end
end
