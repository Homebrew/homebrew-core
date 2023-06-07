class Stanc3 < Formula
  desc "Stan transpiler"
  homepage "https://github.com/stan-dev/stanc3"
  # git is needed for dune subst
  url "https://github.com/stan-dev/stanc3.git",
      tag:      "v2.32.2",
      revision: "bcbf83c52c76018ce4a6cd86233de1601ddf9422"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b40bb946526bd9fca5832f864526e76de1445cac36e20b5a9855a256b43c7d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d873cf39e57996a690c5a9b98a553c9c43c1b8b756a00067019626c6d77af7fa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "46609f4cff24ecd2d3b49ff95c7f748179d4c809bdce8e62f5d2bf77335dbffd"
    sha256 cellar: :any_skip_relocation, ventura:        "5e9f7124184ec9afe926f667d742838150befbfa803aba62918d02673e81d6b0"
    sha256 cellar: :any_skip_relocation, monterey:       "2052622b2ab8035d8fa5f9ee2004dabf1e450a3193857f4cbba35b679aa7f0ad"
    sha256 cellar: :any_skip_relocation, big_sur:        "2499e463f55f18225b4d79c942d1ccc0e747f42003176e58688a6e6c80dea998"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e684d8fd2b13d3d1f02fc304e8b6bf205288a8806fbdbbbfffc9ca10480465f"
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
      pkgshare.install "test"
    end
  end

  test do
    assert_match "stanc3 v#{version}", shell_output("#{bin}/stanc --version")

    cp pkgshare/"test/integration/good/algebra_solver_good.stan", testpath
    system bin/"stanc", "algebra_solver_good.stan"
    assert_predicate testpath/"algebra_solver_good.hpp", :exist?
  end
end
