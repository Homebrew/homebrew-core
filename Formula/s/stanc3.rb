class Stanc3 < Formula
  desc "Stan transpiler"
  homepage "https://github.com/stan-dev/stanc3"
  url "https://github.com/stan-dev/stanc3.git",
      tag:      "v2.39.0",
      revision: "739471362446086911f1d6472c19ae0749c366ea"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "02b4e25206b4be239bcad0c3837ff720b16a376d3bc5b24531ab72c3da42adae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09a7162513f3499e616c3358585bfce78d8ea40eb09851133048c2ac90d4d11b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48d84f89522a49cafd3563e5f883426ac01086de3a0c04a911d74e727fdcccc3"
    sha256 cellar: :any_skip_relocation, sonoma:        "1dd2b661994371d8d740b9bae9ef8301d199d78800a68a2113a0b9f838052541"
    sha256                               arm64_linux:   "e0bd96aa2ce46d8fe0f460f2c5816298a9d1d9293423da28250e39fb45e12ce6"
    sha256                               x86_64_linux:  "04b8f67709e2391c1adc4d55e154723f0282e9fae34b6dfda67e7b1d05ddadab"
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
