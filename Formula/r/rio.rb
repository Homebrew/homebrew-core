class Rio < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://raphamorim.io/rio/"
  url "https://github.com/raphamorim/rio/archive/refs/tags/v0.2.9.tar.gz"
  sha256 "0dd22ff4654887a53f309c9b56a4100c7ffefb28ebdeb489289de2773b36d995"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b2ac352e02895999877259d887486028ec8cec2b1303f02b6f75912db66b562"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2abab81c5f7e0e3f1815bdf8a539a3804d4939599053d010d1fc9c7fddb0053c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f8ec20c88ec7b81434c04e4f4e8710975af60324ce9d999c3f435112453d7572"
    sha256 cellar: :any_skip_relocation, sonoma:        "e70676d224670e22148280367e77415d526937639dfd7c44d93109ed4520b167"
    sha256 cellar: :any_skip_relocation, ventura:       "ad4dae401099d84b5b6e5e1bd5d609fe1f1d6477e40df630ee7e3907e5596cfd"
  end

  depends_on "rust" => :build
  # Rio does work for Linux although it requires a specification of which
  # window manager will be used (x11 or wayland) otherwise will not work.
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args(path: "frontends/rioterm")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rio --version")
    return if Hardware::CPU.intel? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    # This test does pass locally for x86 but it fails for containers
    # which is the case of x86 in the CI

    system bin/"rio", "-e", "touch", testpath/"testfile"
    assert_path_exists testpath/"testfile"
  end
end
