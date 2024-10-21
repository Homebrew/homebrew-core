class Typst < Formula
  desc "Markup-based typesetting system"
  homepage "https://typst.app/"
  url "https://github.com/typst/typst/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "5e92463965c0cf6aa003a3bacd1c68591ef2dc0db59dcdccb8f7b084836a1266"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/typst/typst.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5586435036b1ba98415dda2c346ffd7756a888bcb33a9447ec0618c52ba7fd8e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af2d66c4beed4da51ef9f3ca8818b3df5986a3b98f8c73d48d123634e3c88d05"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "56b6fc67564c350e86b8d1370f98d197c7aa1c83a194cb464071cc1f9e89f83a"
    sha256 cellar: :any_skip_relocation, sonoma:        "130bf8405ef2f904419776a5672d37717c91cdb58899c4978e55c7a3a0c19bc7"
    sha256 cellar: :any_skip_relocation, ventura:       "cccad3f48cce4a2a3d38850f978866c7ae2cff9673cbfb83cae7a055ee6ff4fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66c9c3b7c7e3899fef7daacea96eb2a309add3524747e2fd4164a4afb9175169"
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
