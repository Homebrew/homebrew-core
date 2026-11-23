class Vedic < Formula
  desc "Simple Sanskrit programming language"
  homepage "https://vedic-lang.github.io/"
  url "https://github.com/vedic-lang/vedic/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "2d0fe84427503f3ab09ea9687827de6d386e6804b2ec20ab61a4c41dbde0c454"
  license "MIT"
  head "https://github.com/vedic-lang/vedic.git", branch: "main"

  bottle do
    manifest_sha256 "eb25dbabc3633a72d5e7f5a04c70ed9dd795f991ca461262171b3c9d1f2bffac"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d4123eee0e82e625d6a22920993de0e1f9a888b311f585889deb7f78c088cd60"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cf46488aa74b20585c20b44f5efb46a29663a1638822815343c0e35519c6650e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4d7caa35ccf687c49acd26b7f30d2ebf8a179a46a8e6e9cc56af52bdb056d407"
    sha256 cellar: :any,                 arm64_linux:       "0f37fb7ddaa568ca9a18bf8fff0c821af794150e02ac0ee1adbdf6f57c26de8d"
    sha256 cellar: :any,                 x86_64_linux:      "3a9e6219b88f0664af2debec42c7373a138968bf7fb5e10e6c4b82eb39b690a5"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    # hello world in vedic
    (testpath/"hello.ved").write <<~EOS
      वद("नमस्ते विश्व!");
    EOS
    assert_match "नमस्ते विश्व!", shell_output("#{bin}/vedic hello.ved")

    assert_match version.to_s, shell_output("#{bin}/vedic --version")
  end
end
