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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e2b31104c3edbbb58342905c27e0146433af3db4b65040e128248126f6989757"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bd74ae2eba6236f2eaa6e04c0550ef19b0a431a1db434ac4e1497dfdc1df5b18"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3c942390b0f1a464cf83ba31e44a8720a5396b36876b6ef43b9412606795ad30"
    sha256 cellar: :any,                 arm64_linux:       "04a777829753b2ecc3a484e32819fafc160760faea9d0e861f4a2029913d43de"
    sha256 cellar: :any,                 x86_64_linux:      "707f5a76e7c7bd461236ff3521ed81ac09a8741600bd3855916bc79a24adca93"
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
