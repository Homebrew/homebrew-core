class Radicle < Formula
  desc "Sovereign code forge built on Git"
  homepage "https://radicle.xyz"
  url "https://files.radicle.xyz/releases/latest/heartwood-1.9.1.tar.gz"
  sha256 "e444d2a5e5850490e00e4b13433e474898517c87e5151ec72610d657ac7c9e7c"
  license all_of: ["MIT", "Apache-2.0"]

  livecheck do
    url "https://files.radicle.xyz/releases/latest/radicle.json"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "086c30e7599b90dfe1d5476d9c91bdd08dd38843358849d24a24f9a6b2e19f78"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c00868c9ef91bc50ef55774dad90c1d5a719aa4edc7c446a5294543a6495371"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "913934f0041be9a73e0dd021079dcc991f92ed2ed9e662872df2b3e779cacf72"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9fa0ea87fa596c11dbb68bc7646ed5dbcc2889f72965eac23c8964168d3014f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9d06b1668b9cfd61e1e3b0c249ba7956ad828784dacf504e575d38c03e9282b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad6cd5851cdf132edcaa41b796b3ab09277c2ed4330c60e3139c582a5c666328"
  end

  depends_on "asciidoctor" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssh"
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["RADICLE_VERSION"] = version.to_s

    %w[radicle-cli radicle-node radicle-remote-helper].each do |bin|
      system "cargo", "install", *std_cargo_args(path: "crates/#{bin}")
    end

    generate_completions_from_executable(bin/"rad", "completion")

    system "asciidoctor", "-b", "manpage", "-d", "manpage", "*.1.adoc"
    man1.install Dir["*.1"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rad version")
    assert_match version.to_s, shell_output("#{bin}/radicle-node --version")

    assert_match "Your Radicle DID is", pipe_output("#{bin}/rad auth --alias homebrew --stdin", "homebrew", 0)
    assert_match "\"repos\": 0", shell_output("#{bin}/rad stats")
    system bin/"rad", "ls"

    assert_match "a passphrase is required", shell_output(bin/"radicle-node", 1)
  end
end
