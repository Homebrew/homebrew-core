class Trunk < Formula
  desc "Build, bundle & ship your Rust WASM application to the web"
  homepage "https://trunkrs.dev/"
  url "https://github.com/trunk-rs/trunk/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "d9cd27e3e996650eef04846471eb869c74dffb4317953250ae731cb86e4ea410"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/trunk-rs/trunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "443448ee8930db125faa3c4491eaa483ba4f45cc784e5e9d7f2b39bb45b2057a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a6a2a40db359e7fb94076af7a3930d70eb98409132157f5cf36e9f3eb0122379"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1bc6e178c3de4084fb6e3ea15faa0784ce8aed85fc3876fed6d87b2c0fa1373d"
    sha256 cellar: :any_skip_relocation, sonoma:         "e5791fb66d59133ea0fe2eec83d9c0f996362147b773b41f74bac717ef45e8b4"
    sha256 cellar: :any_skip_relocation, ventura:        "2746362976cee57b86442e30b2c4a2876b2699c8447c6b7da25262be0d363fa3"
    sha256 cellar: :any_skip_relocation, monterey:       "eaca87e788875eeba84dc4041c737417fbad5540e03eced5ec4292eab597f725"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e0d0f747a23a29f86505c1519fa648b9ff968e996663cef36b23942a2d20be5"
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
