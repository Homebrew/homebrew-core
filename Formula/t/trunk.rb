class Trunk < Formula
  desc "Build, bundle & ship your Rust WASM application to the web"
  homepage "https://trunkrs.dev/"
  url "https://github.com/trunk-rs/trunk/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "b8ed1ba9a048d71e0056e2b93c06858d68df25796d0d5515754b1c8610f368aa"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/trunk-rs/trunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "25708da901b4fe769ddc337b74f1f11ca0519ad8a89697c6c83f22d86f673471"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "55990155e8a119413b4ffcb863f43da98ae3188ff78979edc97655695ab6b0ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e68834434656c2a5a3d1c676c80b35cf48902da01770cf36d5906b6508326c54"
    sha256 cellar: :any_skip_relocation, sonoma:         "e25d7a100d7a7bc452d0c3bfebf5f29febffd99a8d8e660368a5e303785ff08c"
    sha256 cellar: :any_skip_relocation, ventura:        "d904131394a9dac0c2e73c932cb817d9122eaf5fd0a40568924c1bbaf387ded1"
    sha256 cellar: :any_skip_relocation, monterey:       "9eb2035f1490c5b586c647da568db4fc1eb461df0b2b54727fcfd99414e0eed8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db1c0e5ef5e3309d441c420af5a012d243c906e6c74102740d0b77233c537f19"
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
