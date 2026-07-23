class Stanc3 < Formula
  desc "Stan transpiler"
  homepage "https://github.com/stan-dev/stanc3"
  url "https://github.com/stan-dev/stanc3.git",
      tag:      "v2.39.0",
      revision: "739471362446086911f1d6472c19ae0749c366ea"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "801baa07706b72c4d489abdff6ed987b71be14c85caa878fe4ba196c42ab3f21"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b1807dcba8574e4eadd96d6e25e894560125921a103ef3a09c534dac80593a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3e42a84e539e4a08369f282f2ddb9fca1bec5ea1cb89c705f70eaf6e327bd42"
    sha256 cellar: :any_skip_relocation, sonoma:        "77703df7b945ecbe94f40cd97d5ef4b0fa491110a16f4c7db2457d3bf56ee19e"
    sha256                               arm64_linux:   "f896cb1a403c1ead0df52f40637511b7dd6ea94dad519af28029a68aa5a8762e"
    sha256                               x86_64_linux:  "5d1a3c2fa48e2069cd36174d384fe74b92c5acc79bb7f1eb583e89723bf618d6"
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build

  uses_from_macos "unzip" => :build

  def install
    # Workaround to build with OCaml 5.5.0
    inreplace "stanc.opam" do |s|
      s.gsub! '"ocaml" {= "4.14.1"}', '"ocaml" {>= "4.14.1"}'
      s.gsub! '"core" {= "v0.16.1"}', '"core" {= "v0.17.2"}'
      s.gsub! '"ppx_deriving" {= "5.2.1"}', '"ppx_deriving" {= "6.1.1"}'
    end

    ENV["OPAMROOT"] = buildpath/".opam"
    ENV["OPAMYES"] = "1"
    ENV["OPAMVERBOSE"] = "1"

    system "opam", "init", "--compiler=ocaml-system", "--disable-sandboxing", "--no-setup"
    system "opam", "install", ".", "--deps-only", "--yes", "--no-depexts"
    system "opam", "exec", "dune", "subst"
    system "opam", "exec", "dune", "build", "@install"

    bin.install "_build/default/src/stanc/stanc.exe" => "stanc"
  end

  test do
    resource "homebrew-testfile" do
      url "https://raw.githubusercontent.com/stan-dev/stanc3/2e833ac746a36cdde11b7041fe3a1771dec92ba6/test/integration/good/algebra_solver_good.stan"
      sha256 "44e66f05cc7be4d0e0a942b3de03aed1a2c2abd93dbd5607542051d9d6ae2a0b"
    end
    testpath.install resource("homebrew-testfile")

    system bin/"stanc", "algebra_solver_good.stan"
    assert_path_exists testpath/"algebra_solver_good.hpp"

    assert_match "stanc3 v#{version}", shell_output("#{bin}/stanc --version")
  end
end
