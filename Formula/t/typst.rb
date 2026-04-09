class Typst < Formula
  desc "Markup-based typesetting system"
  homepage "https://typst.app/"
  url "https://github.com/typst/typst/archive/refs/tags/v0.14.2.tar.gz"
  sha256 "70a56445020ca05efc571c7b07a1a9f52eb93842d420518693c077ae74e54142"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/typst/typst.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2738746c9daf5fb61f4876795e566c5588ff02470c327c0d3f6af4db503499c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1b783df0ce10158ba147e57272e785e396b8fcbb0b3b3de9ac0058c357acbd8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e3adc8d6a1705b65e34c942b82124138eea08a64474690e1689fe6c1814248e"
    sha256 cellar: :any_skip_relocation, sonoma:        "62962c34e2c3f8fc075fa8ca04e88965c2ae2715d09b96607781230eca0a8eac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad6687a01c4aa1c72e513d29f57160feea70698a748c6556308d573b091b7603"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2fabd914210b5cd80e65fd8884ef448f4317920ab09dc890b07578947f9da1bb"
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
