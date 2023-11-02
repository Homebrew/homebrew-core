class Typst < Formula
  desc "Markup-based typesetting system"
  homepage "https://github.com/typst/typst"
  url "https://github.com/typst/typst/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "741256f4f45c8979c9279fa5064a539bc31d6c65b7fb41823d5fa9bac4821c01"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/typst/typst.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f93127694ce17a62ce774396147e2e9291c5b18f58444841d54329e122aee843"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ccc09f1dfe0d390ca9eaf828b0fc646aa8786c3e760852dfb0c6ad089c5159b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cfe6f8479a8c0d805eb17fd0241ec18a3bb0d9af7144e5b0f3371d3a1091dd8e"
    sha256 cellar: :any_skip_relocation, sonoma:         "34a5123cab4c88ae36adb3c4398312a6e24794968796378741ffca70834f7d64"
    sha256 cellar: :any_skip_relocation, ventura:        "3f04fceb272bf64d2a0c15b5361958e8dfa01eb73a0f1f3ea463e11c747d5d73"
    sha256 cellar: :any_skip_relocation, monterey:       "c0586e2944cf447a1b03fc8b50c3e497b5931cbe6aaedb3f35c66cbd3a9bd6f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ae77996084d5770fa69bf4a78d44691901c49bb92d1d6c1d8e3f1d6dd2ccfe5"
  end

  depends_on "rust" => :build

  def install
    ENV["TYPST_VERSION"] = version.to_s
    ENV["GEN_ARTIFACTS"] = "artifacts"
    system "cargo", "install", *std_cargo_args(path: "crates/typst-cli")
    bash_completion.install "crates/typst-cli/artifacts/typst.bash" => "typst"
    fish_completion.install "crates/typst-cli/artifacts/typst.fish"
    zsh_completion.install "crates/typst-cli/artifacts/_typst"
  end

  test do
    (testpath/"Hello.typ").write("Hello World!")
    system bin/"typst", "compile", "Hello.typ", "Hello.pdf"
    assert_predicate testpath/"Hello.pdf", :exist?

    assert_match version.to_s, shell_output("#{bin}/typst --version")
  end
end
