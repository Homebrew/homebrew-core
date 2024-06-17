class Rio < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://raphamorim.io/rio/"
  url "https://github.com/raphamorim/rio/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "076609d37a5ec1156a4f623d60913f3e4a48245687277838e80d28c645945e72"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7636866c5f3dc6947b77d24f00d54ee49b434ccf3be8dd198ed223e7e5659009"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "37a57ab3c93efab68d2925be5a52040a194d5896dc6651132f64f31e240b960a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b239e4fd82286d5a17aa83626ef4709fc991248f15960599571d419d1091068"
    sha256 cellar: :any_skip_relocation, sonoma:         "b251195db947cb3664e3c5ffc15756731e414771da5ec4acf61abc85e0c9a879"
    sha256 cellar: :any_skip_relocation, ventura:        "0884d0b4bb69b08252b7a707189f8e5fa2827c4b0f9b9698bd8194f0c22bcfcf"
    sha256 cellar: :any_skip_relocation, monterey:       "d585c3aaaff69e2f96e68c4597974b555392c2f148eaed90afbb392be4896b70"
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
    assert_predicate testpath/"testfile", :exist?
  end
end
