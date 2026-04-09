class Stanc3 < Formula
  desc "Stan transpiler"
  homepage "https://github.com/stan-dev/stanc3"
  url "https://github.com/stan-dev/stanc3.git",
      tag:      "v2.38.0",
      revision: "e05ba2b1c68af5abf6bb4ce4279e82b6d1059f8b"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "052f27eccaa5dd5a4b9c441846e3741cee2b3e5e733d52094db2c3e39e7dca54"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d835afe8912f71f5772dcf3384bc177b4dacea3906acb13e116e1dd9adb7322"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb02b223a6c2b33b7284e59ce8f068816246aa13057430eb6a5269de7cca0964"
    sha256 cellar: :any_skip_relocation, sonoma:        "0bc2c520dc35d62340f74eea4243e70921af2d4c4e8b991edee6016e77781405"
    sha256                               arm64_linux:   "e0581e5129dd2feeb742d8bf10db92be453f5fc081c55bbf490f37eb9b6769c6"
    sha256                               x86_64_linux:  "3b13da81774f275c774e28c92965d9469e136f9afbf2389d1f76cceace80ddb3"
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build

  uses_from_macos "unzip" => :build

  def install
    # Workaround to build with OCaml 5.4.0
    inreplace "stanc.opam" do |s|
      s.gsub! '"ocaml" {= "4.14.1"}', '"ocaml" {>= "4.14.1"}'
      s.gsub! '"core" {= "v0.16.1"}', '"core" {= "v0.17.1"}'
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
