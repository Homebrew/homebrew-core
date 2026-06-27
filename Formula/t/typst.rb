class Typst < Formula
  desc "Markup-based typesetting system"
  homepage "https://typst.app/"
  url "https://github.com/typst/typst/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "5044bd12138491c6e880df0e09056a9ae4607d937c73962d5806402ae6ee96a6"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/typst/typst.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6615a3d781b2026e0b42be2bc1fb543dfd770198c3c7a6879eb27f0d0df3b2f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1596ece9c523d719dd69fb2d758daaa5bc1a0eac6595b55748d5d1ffb4c020a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e22d95274070619c89be6a43d01f3ffd0380fa94cde9bf1956adecd5a9d6dd6"
    sha256 cellar: :any_skip_relocation, sonoma:        "370cb1fa6634ee4f3fe1bb7c330dcccc255933a6a1dac2c6f6a0c4da30864a5a"
    sha256 cellar: :any,                 arm64_linux:   "ffc318062f7d20423ace65c6a4dc6f613ed789818a50d109028243284b6fa297"
    sha256 cellar: :any,                 x86_64_linux:  "e5154ae08d74adaaa717f5fe2ae1b651e66e3b7fa09066c93e95ef524cf72962"
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

    man1.install buildpath.glob("crates/typst-cli/artifacts/*.1")
    generate_completions_from_executable(bin/"typst", "completions")
  end

  test do
    (testpath/"Hello.typ").write("Hello World!")
    system bin/"typst", "compile", "Hello.typ", "Hello.pdf"
    assert_path_exists testpath/"Hello.pdf"

    assert_match version.to_s, shell_output("#{bin}/typst --version")
  end
end
