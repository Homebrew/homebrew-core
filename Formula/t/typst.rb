class Typst < Formula
  desc "Markup-based typesetting system"
  homepage "https://typst.app/"
  url "https://github.com/typst/typst/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "39df9db43c792b0ab71cde97bdc03d4763fff7d3525b67d549ffc8bfc99b6395"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/typst/typst.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3eacec25746075f53980844a1e38958a0a3f8343a37dc6af416895ecc1bcac7f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da7726e20b43313f179ef947b797477dad8465e5d1b24817a290a0cdcde2c611"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cbf24d69a7de5884455c84e0f691e3d1d8bcbfc9c0880ce1e0cd9ed4e559770a"
    sha256 cellar: :any_skip_relocation, sonoma:        "110b0df6556bc0413ba05499c4e56d78ddc7e7887bb7b65a4eaa5acce8b4fa9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "befee91fab89142a1dd0a56f737c1270b506e12f99857caa233834e16cf4526f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "500554a3e43e98514734acffb5c7aaaf881dbc9f9f76e51ef09dceecfca5a060"
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
