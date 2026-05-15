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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "34545b51cb33bec8fbeac1222e565be8cd15c9bbc9d9fed4204dd6e31fb5dfd9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44c502f24d3975fb3a20a97d42def993a56aba17d51d80ffa8838034583075a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d58f5fe25736f51bbddef93b63d6cd5682f7c8a7020b4fe64c61a6a1c8d1e8b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb1151556ba90bdf9029a89e4811cba1a89022039aa8e0d908c5526dd1cefd85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "033b01a508cdfebe47ba179e9d3fdda88dec6c8a4aa304943c79df87c8ebd4be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8d2086f63462492179123fcc541be069bb9aedd2fb7f1abef536b409f697161"
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
