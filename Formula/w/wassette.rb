class Wassette < Formula
  desc "Security-oriented runtime that runs WebAssembly Components via MCP"
  homepage "https://github.com/microsoft/wassette"
  url "https://github.com/microsoft/wassette/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "193d9f0db0f03cbcee99c522602d8e886b824962888fe80e8780cd178ccc700f"
  license "MIT"
  head "https://github.com/microsoft/wassette.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e317cf258893b2cf4b6b12705ca68bc912ba034e50baf5e8b9466316be4a868c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ede498835acbf727c2694e8a0150e552ec9332ec3ea7915b9b68882d895fa5a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7fd50b6cfd70b3b537da917308d2692c496e394b81635c599e486307cfb0935d"
    sha256 cellar: :any_skip_relocation, sonoma:        "de3083cb79c202d582085af077606110d6878ec2741803e647d5b28ead49a6ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c574434cb5ba090708f526e6f78aa9a5df53885251f3a7ecaf502cbc01b67f93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82b9fb444ef4a36f8d10037834d0c786c8f411ca7059fc36555b61bc417caffd"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wassette --version")

    output = shell_output("#{bin}/wassette component list")
    assert_equal "0", JSON.parse(output)["total"].to_s
  end
end
