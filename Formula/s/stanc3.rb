class Stanc3 < Formula
  desc "Stan transpiler"
  homepage "https://github.com/stan-dev/stanc3"
  url "https://github.com/stan-dev/stanc3.git",
      tag:      "v2.40.0",
      revision: "d58446e631b02cacc5355e373defc6092a684554"
  license "BSD-3-Clause"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8362ae6dd79629b93881fdbc40a4703ca5cad38465677f52fb55f7107faf8f6d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "688c52bc95aa7193e6e7bf88735e2744f3d5e19a457b5a4f28f467f34e14c030"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f9a0e754136b9f6377f4b8e9f4c328cfff3e6b20c39b8bf4b5a05df5b59b50d5"
    sha256                               arm64_linux:       "8ce8ffa68f0223ffcd047f88dec02f4710915ef5a53ae4988f7732847335fd51"
    sha256                               x86_64_linux:      "cc823a4d9674fd493e389edea82d8f8a4a4120bcee68537e27eb08320264970f"
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build

  uses_from_macos "unzip" => :build

  resource "homebrew-testfile" do
    url "https://raw.githubusercontent.com/stan-dev/stanc3/2e833ac746a36cdde11b7041fe3a1771dec92ba6/test/integration/good/algebra_solver_good.stan"
    sha256 "44e66f05cc7be4d0e0a942b3de03aed1a2c2abd93dbd5607542051d9d6ae2a0b"
  end

  deny_network_access!

  def fetch
    system "opam", "init", "--compiler=ocaml-system", "--disable-sandboxing", "--no-setup"
    # Upstream pins an exact OCaml version, so build against ours instead
    system "opam", "install", ".", "--deps-only", "--download-only", "--ignore-constraints-on=ocaml"
  end

  def install
    system "opam", "install", ".", "--deps-only", "--ignore-constraints-on=ocaml"
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
