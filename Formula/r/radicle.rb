class Radicle < Formula
  desc "Sovereign code forge built on Git"
  homepage "https://radicle.xyz"
  url "https://files.radicle.xyz/releases/latest/heartwood-1.8.0.tar.gz"
  sha256 "c1de84fee59ae1c69fac5e42c932f4d2765a85630b27642f77792fc765948097"
  license all_of: ["MIT", "Apache-2.0"]

  livecheck do
    url "https://files.radicle.xyz/releases/latest/radicle.json"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4d208f5a25bbab7fa45a173aa7fc5d9a2110553a59edab74c64e885c1f4f7d20"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ae0b766779e9b8869000ef68776693e0c7709c9abc40dadb0a5489d4660ede0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d0104b90ae5a07c926ead686f255078e6ea512fe4ea52e0390a904b860eecc0"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8f4631c56c352441e6000fec0a921b9655cd54e064b669bbae56474ccb09076"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e42a705b7fd6dd5203491791ea3943af98ea6b81c6da04f0dcf3bba476c8563f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "326623a7b34c86eef1c598e00f5be67fe3a0fc730ed38fdda76876512c1cdc33"
  end

  depends_on "asciidoctor" => :build
  depends_on "rust" => :build

  depends_on "openssh"

  on_linux do
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
