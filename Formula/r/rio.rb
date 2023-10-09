class Rio < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://raphamorim.io/rio/"
  url "https://github.com/raphamorim/rio/archive/refs/tags/v0.0.22.tar.gz"
  sha256 "936fa0f1d648016a53f845c6a24d91eaa2cc93e08b7a4d08e98417e294ba40ab"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3cef7d51c7d118590f41e7f6a91c87bdc3c6932d2d749dceb9a5cf13dbcb9236"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a0841bc9b5b40ce506ed1ed601fbbdd168b887a01e9bcd81b768faade748062"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0991b71330bc794d8ee08e5af52ff0890887c8383bc2bac2178cea770fdccde1"
    sha256 cellar: :any_skip_relocation, sonoma:         "680e472741e450cd6bf5a74c4a271de980ffda88b4b2f6e924f11215f4a35384"
    sha256 cellar: :any_skip_relocation, ventura:        "94c8fc31e286c2bfb2c4c76a4c2f6ffdce1bb556f0c91fa11a6668c8b9dc28fe"
    sha256 cellar: :any_skip_relocation, monterey:       "bf765a763a4d227f133e98e8cc5a18ba472b3a0c42d031122d8f7b9de3852bde"
  end

  depends_on "rust" => :build
  # Rio does work for Linux although it requires a specification of which
  # window manager will be used (x11 or wayland) otherwise will not work.
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args(path: "rio")
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
