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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b965b3c0023803f4c26398b49f6652faa0de4055f139876e18a7c123c98ced96"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "999773962cc045c87fc9090bff3e408dbd1497e0ebbd601852578bc0ebb0ebc7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef24a1d8b32b076a98fafe4f44b19956e0a4426accdb87f5758324ad8a1658f3"
    sha256 cellar: :any_skip_relocation, sonoma:         "e7984ce9fa4c59d9431ad84accc6c1a6adb9df2643f1d8af4d4dc6b823f067df"
    sha256 cellar: :any_skip_relocation, ventura:        "e7d8ae5446419c5c05b76b4e7a9c10e2d902d6018f688cfe921ba7dc45e4377a"
    sha256 cellar: :any_skip_relocation, monterey:       "680f33ef030929311c874d6c73f68983df3f452efb31f531147d3e337bd91d28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "613aa323a4c8dedb7abf788abf3d021f162f3a14bdef507265cc08697005b5bf"
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
