class Typst < Formula
  desc "Markup-based typesetting system"
  homepage "https://typst.app/"
  url "https://github.com/typst/typst/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "2ffd8443668bc0adb59e9893f7904fd9f64dce8799a1930569f56a91305e8b71"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/typst/typst.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c187e0b7e86411fb7925307d34c2e63429103cee0da30bac01479d1abb7b0160"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "808d9896ed7680fbb788182c8de04914229f1fe36b4e8d48a826ce7f9a78d471"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9d7fded4d1f467a78524ec9aeb9cb81ed08f5c0da380f0e81f91b7dc28772ac1"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4af1021420e590f933035c3f996e70ec27131c0d12e7404d3abc7a0f68320b6"
    sha256 cellar: :any_skip_relocation, ventura:       "39ce285d7af6080b660db41590acf877b3be5f51327e4e4914b7c324a65e5be0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24d7ad7e8d31a809d124f49cd4d07c84c9b8e8b68f8b006d8092edd7b3e371b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c411beb9f7379cbec800b101ded8249d3f02ea469a5a312b328c81806f7924db"
  end

  depends_on "pkgconf" => :build
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
    assert_path_exists testpath/"Hello.pdf"

    assert_match version.to_s, shell_output("#{bin}/typst --version")
  end
end
