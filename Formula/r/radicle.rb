class Radicle < Formula
  desc "Sovereign code forge built on Git"
  homepage "https://radicle.xyz"
  url "https://files.radicle.xyz/releases/latest/heartwood-1.6.1.tar.gz"
  sha256 "a4806357baf162263002a24fc24660dfed7a43d566a24fc5428b0948d67e2011"
  license all_of: ["MIT", "Apache-2.0"]

  livecheck do
    url "https://files.radicle.xyz/releases/latest/radicle.json"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f82b1f36f71d6c52b290713efc2b47b4f6c020cb298ce6926938dd9a391dfbae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fac4a06307d6a25d8b3b405e96e1a6af085e99101477ba9b6d33acab6c8b474c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2552aaa82a06b43a195cdef7e8cf5ff1e75523736c6544bccb3912cbf893d0aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "813d5d88508b7895c495cd83d7259aee6058a9d48a4aa18af53f3cf54796c173"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d90155b9be9457d45102ef00b1f88177e9750a7090b4d347edbd91184d1a5d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9e82ca7d7210cf9bf27a910f505db24197c40d763359da8d6bfe349bb8590e8"
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
