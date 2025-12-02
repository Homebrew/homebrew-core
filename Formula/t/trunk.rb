class Trunk < Formula
  desc "Build, bundle & ship your Rust WASM application to the web"
  homepage "https://trunkrs.dev/"
  url "https://github.com/trunk-rs/trunk/archive/refs/tags/v0.21.14.tar.gz"
  sha256 "8687bcf96bdc4decee88458745bbb760ad31dfd109e955cf455c2b64caeeae2f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/trunk-rs/trunk.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "93022640040f9f21249a52ac60776e812e0aed4a02b9e0b61676eb8b51ac6f96"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f29f737a25367f9d601004ab3c69d5af49388d105dbbf4de4342e9b26bb19235"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e353a529700001a2d583d8b5c7b64fd33437b62cb06df847d87be200750a7d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f527d08ece51ec56bc8f5cab717340954024b412c948739ae4dba0f5aa5c203e"
    sha256 cellar: :any_skip_relocation, sonoma:        "327a4675ef5bbe597bb701f9bf8fae1f5c0a5158a9b6e6b995e0beadd480adf6"
    sha256 cellar: :any_skip_relocation, ventura:       "1a95cdffa128c65c96942b7d28b0037c230ee87f89c426253665068717bfed7e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f03d00804c927fda2616c5ac7ad5a145bf84e361d6b36369a6fc4383562006d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75d36fb9a7d305547ce7580004d3da051ddd6089a8338fff63e2a033efb17578"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "bzip2"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["TRUNK_CONFIG"] = testpath/"Trunk.toml"
    (testpath/"Trunk.toml").write <<~TOML
      trunk-version = ">=0.19.0"

      [build]
      target = "index.html"
      dist = "dist"
    TOML

    assert_match "Configuration {\n", shell_output("#{bin}/trunk config show")

    assert_match version.to_s, shell_output("#{bin}/trunk --version")
  end
end
