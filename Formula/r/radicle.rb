class Radicle < Formula
  desc "Sovereign code forge built on Git"
  homepage "https://radicle.xyz"
  url "https://files.radicle.xyz/releases/latest/heartwood-1.7.1.tar.gz"
  sha256 "3263219e470862cc2489ed684c6d947ec6d462354954f5e2ac1aba0939d851a8"
  license all_of: ["MIT", "Apache-2.0"]

  livecheck do
    url "https://files.radicle.xyz/releases/latest/radicle.json"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e71464307cab48d0fa169d010bb1b6207289a3ed02e54b31cf6d6a2a4cfdcc0a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78a078aea6cf4d58e7f973890afef6a318186c5e5cf02102297365380b105509"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd67bfec110bd744f7c16cd41a0d95bb0067553182f2130e968acb0fa3695512"
    sha256 cellar: :any_skip_relocation, sonoma:        "c03efe8cd243725f5b7bcbdb4fd8f89863cef6d29a06d91c39ff2dc9ce5f4a8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c667b42aff1b507a927bb5033f70c11cf84dd27cb84e3f05bbc2bc0f86bbcf7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "727c6f48e6f98916cf6d61188c15bfb13e86b103816cdfbe381b3ee764a38257"
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
