class Websocat < Formula
  desc "Command-line client for WebSockets"
  homepage "https://github.com/vi/websocat"
  url "https://github.com/vi/websocat/archive/refs/tags/v1.14.2.tar.gz"
  sha256 "cb49afdb6c108c5be9ae2e78d72f4c31cd2e464d4e3a9faa1e9f958b61e53e3d"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5606fa8542ab5bdd17d28cde0a4752e893dca6cac1929ed67bbe85bf72dedffc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0ed50390813937d6c5d900263ca1453be8dda74e7f0f0ce34dce44b2d990ebb1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "55e3ed26ad23f3edf03558dc5ff37483522a18701daff6acb1e491a4d0ee5d64"
    sha256 cellar: :any,                 arm64_linux:       "fa3519bfc7f2ba940effe6ae99cdc6e1c7dc40c02b0b4e7bf6247099d7e4e74a"
    sha256 cellar: :any,                 x86_64_linux:      "5abe0c310158004de8a2688f0778ef483bd8ade5ea3ac4f367e387fb4711ef61"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  # Match Cargo.lock's package version to Cargo.toml for locked builds.
  patch do
    url "https://github.com/vi/websocat/commit/dbeaa84544e054014a23d199de5c490c8989248a.patch?full_index=1"
    sha256 "c7473d519369f89978dfcfe7c8eed285e085b87a955cd3394737528c66a2e50a"
    type :unofficial
    resolves "https://github.com/vi/websocat/pull/319"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(features: "ssl")
  end

  test do
    system bin/"websocat", "-t", "literal:qwe", "assert:qwe"
  end
end
