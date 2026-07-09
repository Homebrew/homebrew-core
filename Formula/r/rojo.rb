class Rojo < Formula
  desc "Professional grade Roblox development tools"
  homepage "https://rojo.space/"
  # pull from git tag to get submodules
  url "https://github.com/rojo-rbx/rojo.git",
      tag:      "v7.7.0",
      revision: "bcadc97de27ab3800e915abcb72c6c7a3c30f363"
  license "MPL-2.0"
  head "https://github.com/rojo-rbx/rojo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4a2d2340181f55e3a7e830dae54658354627f7857f565d1051e57501a60a99f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca3f71f354df37affbed09735fa2837a90b2ee1b95a414043084aed88b49ed1d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "925ec4ed4ad786d0f66653cf74718aae999fb3a48d8add78199be1c7d972940e"
    sha256 cellar: :any_skip_relocation, sonoma:        "314a73502fca77c28f9069dc13528132d0e667876739547efe1f42b6748fb831"
    sha256 cellar: :any,                 arm64_linux:   "f6c3268f919bd8b3741a062a97ee664734415baad1759aeacf8e5abe298ba1cd"
    sha256 cellar: :any,                 x86_64_linux:  "d0f110a75c6e1e9bbd18b64e2705182cd90d0ec520d7266232f8cbd1e603e9e3"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"rojo", "init"
    assert_path_exists testpath/"default.project.json"

    assert_match version.to_s, shell_output("#{bin}/rojo --version")
  end
end
