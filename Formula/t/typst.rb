class Typst < Formula
  desc "Markup-based typesetting system"
  homepage "https://typst.app/"
  url "https://github.com/typst/typst/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "fd8debe21d5d22d4cd6c823494537f1356c9954cc2fe6c5db8c76c1b126112dd"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/typst/typst.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b8a2ca9d7dd922991dc3c870d68334322ab4396a5ddeae1e6be72ae69d97541e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6d46b37db02e52f90242460c33585c82e4af974d015f3d54d4b12308d5dbc1f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a1616edbd759adc8e589461b4be6928325c71cfb87f4d9cdb52cacfb0930199"
    sha256 cellar: :any_skip_relocation, sonoma:         "27efefec35449432d7a6a3122f30b020e64d502dd0f162ad17ff5c65af7d6065"
    sha256 cellar: :any_skip_relocation, ventura:        "a685024b601d5d32c4df8da1e88c61aaad03afc456d1be2d2a138f25fa95f6bc"
    sha256 cellar: :any_skip_relocation, monterey:       "cd9a33a5d715fcd3c2fffbab2c3d661182cebcdb183a278a2f8d6bd3ae9a2979"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1981101d2e97d813b210cf78c313aa4ec51d029b186e78faf20bb41c8016919"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    ENV["TYPST_VERSION"] = version.to_s
    ENV["GEN_ARTIFACTS"] = "artifacts"
    system "cargo", "install", *std_cargo_args(path: "crates/typst-cli")

    man1.install Dir["crates/typst-cli/artifacts/*.1"]
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
