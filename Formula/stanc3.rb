class Stanc3 < Formula
  desc "Stan transpiler"
  homepage "https://github.com/stan-dev/stanc3"
  # git is needed for dune subst
  url "https://github.com/stan-dev/stanc3.git",
      tag:      "v2.30.1",
      revision: "60c5597a544771416354418d3a3dbe7f9915fcd9"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1ed2ff03c3b0ed17278d021de8ca686a43482b129b0d3ad1edcb339bd99736b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6542782f0ac8ded789a92236f30667a4d18f7c9974d896dd7ae17db3781c7a65"
    sha256 cellar: :any_skip_relocation, monterey:       "72465ad612cd3204952f78bb6389800240d3cd0d154d1d586988ddf85c338bdd"
    sha256 cellar: :any_skip_relocation, big_sur:        "243c793b61bc7c3d61c357a56f97bf29744167d458d05cb861db87aaffd2ec8a"
    sha256 cellar: :any_skip_relocation, catalina:       "397b2a6b50e444771200b1cdfde6ae47621d93b5a17e14553d0f6776bf1ed6c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48541149d82db48157cdc22d769c6b2a240b5b4501ddce374c3773253add7b6e"
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
