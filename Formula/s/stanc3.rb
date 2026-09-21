class Stanc3 < Formula
  desc "Stan transpiler"
  homepage "https://github.com/stan-dev/stanc3"
  url "https://github.com/stan-dev/stanc3.git",
      tag:      "v2.40.0",
      revision: "d58446e631b02cacc5355e373defc6092a684554"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dfe53612ffae4cf72094cd4265d3e2492a03f6bb34b0d0a1486d06eb8569ff5b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0c7b77a3cb300ca440fe6282f8e403fd79c04f243c5199f8888926e137626a51"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "08bfe3a11b10e0c6dcb3a72037a4a510c176eb0d2b315a8d6aa362070bc1267d"
    sha256                               arm64_linux:       "b600d142ba784335f89a054dbeba5822babf856d94f1c5acf994a613e9e2ca14"
    sha256                               x86_64_linux:      "2d5d18812a525f078226bdfbf2b003bb99e831f34da8428f09f16c1c3dc886c4"
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build

  uses_from_macos "unzip" => :build

  resource "homebrew-testfile" do
    url "https://raw.githubusercontent.com/stan-dev/stanc3/2e833ac746a36cdde11b7041fe3a1771dec92ba6/test/integration/good/algebra_solver_good.stan"
    sha256 "44e66f05cc7be4d0e0a942b3de03aed1a2c2abd93dbd5607542051d9d6ae2a0b"
  end

  # Update pinned OCaml to 5.5.1
  patch do
    url "https://github.com/stan-dev/stanc3/commit/a580643374c9390e7c7a9ec3db014ebb65f0e7bc.patch?full_index=1"
    sha256 "4f6489e6144dbada19046eda03b66ad4d120ca8e659b7c7187aa65fc13264807"
    type :backport
    resolves "https://github.com/stan-dev/stanc3/pull/1707"
  end

  deny_network_access!

  def fetch
    system "opam", "init", "--compiler=ocaml-system", "--disable-sandboxing", "--no-setup"
    system "opam", "install", ".", "--deps-only", "--download-only"
  end

  def install
    system "opam", "install", ".", "--deps-only"
    system "opam", "exec", "--", "dune", "subst"
    system "opam", "exec", "--", "dune", "build", "@install"

    bin.install "_build/default/src/stanc/stanc.exe" => "stanc"
  end

  test do
    testpath.install resource("homebrew-testfile")

    system bin/"stanc", "algebra_solver_good.stan"
    assert_path_exists testpath/"algebra_solver_good.hpp"

    assert_match version.to_s, shell_output("#{bin}/stanc --version")
  end
end
