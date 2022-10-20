class Stanc3 < Formula
  desc "Stan transpiler"
  homepage "https://github.com/stan-dev/stanc3"
  # git is needed for dune subst
  url "https://github.com/stan-dev/stanc3.git",
      tag:      "v2.30.1",
      revision: "60c5597a544771416354418d3a3dbe7f9915fcd9"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "178fff04f4394364eab6ce894104979832cc3157979d16f16c192d56a489275b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "784abf24eab6dea8878c1a30e25d793648e8d7b885969973db91f27c6a3a9e8a"
    sha256 cellar: :any_skip_relocation, monterey:       "2695c1bb3960d61576e9cc70212a3597ec683dd20929653d23df4a4ceb9c3f7e"
    sha256 cellar: :any_skip_relocation, big_sur:        "c143caa203a4ffd199af56074e3ccdb83e5ff14e8217146cc4ad00ba51e24807"
    sha256 cellar: :any_skip_relocation, catalina:       "326b30c3aa3fc8468bd9042047c631a8abcf408e049db90d3ed7b721f51a72c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eecce590dbb2f21cd361037b981a85f6be6eaf847fd4492e7604a5fed7f7c315"
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
