class Stanc3 < Formula
  desc "Stan transpiler"
  homepage "https://github.com/stan-dev/stanc3"
  # git is needed for dune subst
  url "https://github.com/stan-dev/stanc3.git",
      tag:      "v2.32.0",
      revision: "2081cb65f00081dc98cbf0431dcce24462deb23c"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4d3f9ac79619f0663aee34bc427086b48c6d060d894e12365db9dde89c3382cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f02da1df49645af3403c0572265411a8a6063a565311edf6a3a351f37f82192"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c3d65804fc6a69c205c24cd1cd40d90929982a5dad9b51be039f279a0dbd103c"
    sha256 cellar: :any_skip_relocation, ventura:        "10d8bffab87d61b3f8a1b2fc27d58b2f45471f6358deaebb1d3556f54122ab2d"
    sha256 cellar: :any_skip_relocation, monterey:       "8beb9d933dac060e2956986cb85c2124d7ae1c7fbe7be434e5f8fc470a50b96f"
    sha256 cellar: :any_skip_relocation, big_sur:        "982530ee53dc94bcebed29e1c7a4c06bf62670149521f2bd0c81be1a8b2c8004"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39d53715494145e17a9ab8ad642d8cea7e4df6d32d0de0fb45c1852e03cbceaf"
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
