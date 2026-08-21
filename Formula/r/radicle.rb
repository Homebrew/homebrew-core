class Radicle < Formula
  desc "Sovereign code forge built on Git"
  homepage "https://radicle.xyz"
  url "https://files.radicle.xyz/releases/latest/heartwood-1.10.1.tar.gz"
  sha256 "d46ca92664fd5b44939b362fe80d82a27e00050f01fa45b58451d5e51655e95a"
  license all_of: ["MIT", "Apache-2.0"]

  livecheck do
    url "https://files.radicle.xyz/releases/latest/radicle.json"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f96f91ae031be34f66030663e724093c5e3678767aaa8ac94f39a04bdd87239"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6fe8244b94215dc5e8a344e6de76a4b7ab78e5206d9b110a290b8d300c12ce71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17b025640876751d56c62acbf97847955b9d8c309da82ce390e06fb4f731fd84"
    sha256 cellar: :any_skip_relocation, sonoma:        "5df4d5587b53b129bd8b6d393dec4cc446f2c7d50f1dd73345d33de3d4d5bb8e"
    sha256 cellar: :any,                 arm64_linux:   "a8e2fbd2e2eb455c4e9c4976d748940eca61371c4cfe64dcc4102a2892a9849b"
    sha256 cellar: :any,                 x86_64_linux:  "281f3f82fefab7ec7daedcef4a132ed3ac41be444d0b41f8b219a12fbbcc06d6"
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
