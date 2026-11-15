class Xtermcontrol < Formula
  desc "Control xterm properties such as colors, title, font and geometry"
  homepage "https://thrysoee.dk/xtermcontrol/"
  url "https://thrysoee.dk/xtermcontrol/xtermcontrol-3.11.tar.gz"
  sha256 "49ea6d3eda0dbcf875363763cefe1818ce6786b9910255ea641d9786bdafd44c"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?xtermcontrol[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "38f0066a8ad185cb36214a5ac6b6989e4864106d8d15523d83c139ed1e8fb4c4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c64d391a46722330134e95e9765d92c5c20cb556f73cd182a7193db2ec41006b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f2f77bc8528460547f51d0df2efe56e9d491050b006ea977ef4a5c1848cb122e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "ab6bcf0269c8f98480fe70e415a67704158a7b280dd937f883014feef8114551"
    sha256 cellar: :any,                 arm64_linux:       "8348006b951d5a75e2e5c17e814d6525192351134f473b1742eec76c35e601bb"
    sha256 cellar: :any,                 x86_64_linux:      "8372ba9c9fec588dacd586686e9a8b824532c98ef8a2436177d490ab06a26871"
  end

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xtermcontrol --version")
    expected = "--get-fg is unsupported or disallowed by this terminal"
    assert_match expected, shell_output("#{bin}/xtermcontrol --force --get-fg 2>&1", 1)
  end
end
