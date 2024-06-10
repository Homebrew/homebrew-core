class Trunk < Formula
  desc "Build, bundle & ship your Rust WASM application to the web"
  homepage "https://trunkrs.dev/"
  url "https://github.com/trunk-rs/trunk/archive/refs/tags/v0.20.2.tar.gz"
  sha256 "0e640fccaf12f155d65a5f846e9551e3d4610e048456f9760ac8cff575c93073"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/trunk-rs/trunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "07968a31b445a3067537679ed7095257895a2999d7e4751efb56a1571e86e46a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1993f33ca0a61b8811b35341386c5d7c2b25da8ecc0066c09604bf7c21c414f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bea4ec20f0c1a3ba3381d7261692e9031ec4ee814444e3708b7fb3047a74a541"
    sha256 cellar: :any_skip_relocation, sonoma:         "426c8ca36874e04477c46f66a544736da842e0e908db6b0a2f7d78fe19fa9dc1"
    sha256 cellar: :any_skip_relocation, ventura:        "b1f6de08cbd8febdc61ee8c5a98b677630726b2367aafd0036f06c3f6d7fbff8"
    sha256 cellar: :any_skip_relocation, monterey:       "bbae8dfd2d9e52e227988518f34ef44c2ed789e21fcd2ed28b31f4463c95ac33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f705e3ce290d9c0d53a1ff3fd59dda8a9b1ccb07c09182c9035c4820b3b3ab20"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "ConfigOpts {\n", shell_output("#{bin}/trunk config show")
  end
end
