class Typst < Formula
  desc "Markup-based typesetting system"
  homepage "https://typst.app/"
  url "https://github.com/typst/typst/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "c07909e01a2a6941e52c9b616e48c209c755eed416d62bcf5583c37a4aca01a3"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/typst/typst.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "534233338dee13f1b93c2e1c08d1e0c6c5fe201f793ba640d938d58666388808"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "37bfa441d1641d246e8663d742f940811688b7cd56b50b29a6177928ed949beb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "baa3a28555bff94f9f6f6154b8ef34458733daec86f22ffb1fd9af01fe9956b8"
    sha256 cellar: :any,                 arm64_linux:       "8e9ac4d200c27bf7d5f96213ddbc0e6ab95710740c598341049df5705d072adb"
    sha256 cellar: :any,                 x86_64_linux:      "ec392c6b39754c10c733dd48a51c67e2eb58a8dac3e66bc3c5d8e033e288e6e8"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
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
