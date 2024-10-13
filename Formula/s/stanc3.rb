class Stanc3 < Formula
  desc "Stan transpiler"
  homepage "https://github.com/stan-dev/stanc3"
  url "https://github.com/stan-dev/stanc3.git",
      tag:      "v2.35.0",
      revision: "b46cc7ecc6ab4bd775de72765ffbc827eeffbdd4"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "bfcdeb07e708b96b17861cff6f500f9e4dd8a7703e195fe67e9c28e20cfbbb3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "252b1a131eeede1c0c7407017a56435bb6a9fc41a4ca518375b6868c56bd9cf2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf510fd16c6abd9fcc3058cd2863d171ffcbb2343990964ce8265f0aed06acb0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6bcd5b99613d10958dc78c088b4ffac062d168ddd4fa58b2696f31281700b66"
    sha256 cellar: :any_skip_relocation, sonoma:         "55126ef12565f1a98391366902eed3d4d0ea81ab5deaa4b9700c365ee5d887a0"
    sha256 cellar: :any_skip_relocation, ventura:        "118a29a7e10032827b6ac2b685ec1b163d25557d50c1f2a8fcb4ae4f885f3113"
    sha256 cellar: :any_skip_relocation, monterey:       "5727e1308fa215cdcf1e95380934fc2a10b72a2a96678cb2525fdf7d3ec590a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15074d4aa26f64aedefacbd4a0f8357cdee32ccecbc3f07c65c2de7c7f36a5ed"
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build

  uses_from_macos "unzip" => :build

  def install
    Dir.mktmpdir("opamroot") do |opamroot|
      ENV["OPAMROOT"] = opamroot
      ENV["OPAMYES"] = "1"
      ENV["OPAMVERBOSE"] = "1"

      system "opam", "init", "--no-setup", "--disable-sandboxing"
      system "bash", "-x", "scripts/install_build_deps.sh"
      system "opam", "exec", "dune", "subst"
      system "opam", "exec", "dune", "build", "@install"

      bin.install "_build/default/src/stanc/stanc.exe" => "stanc"
    end
  end

  test do
    resource "homebrew-testfile" do
      url "https://raw.githubusercontent.com/stan-dev/stanc3/2e833ac746a36cdde11b7041fe3a1771dec92ba6/test/integration/good/algebra_solver_good.stan"
      sha256 "44e66f05cc7be4d0e0a942b3de03aed1a2c2abd93dbd5607542051d9d6ae2a0b"
    end
    testpath.install resource("homebrew-testfile")

    system bin/"stanc", "algebra_solver_good.stan"
    assert_predicate testpath/"algebra_solver_good.hpp", :exist?

    assert_match "stanc3 v#{version}", shell_output("#{bin}/stanc --version")
  end
end
