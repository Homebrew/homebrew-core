class Stanc3 < Formula
  desc "Stan transpiler"
  homepage "https://github.com/stan-dev/stanc3"
  # git is needed for dune subst
  url "https://github.com/stan-dev/stanc3.git",
      tag:      "v2.29.2",
      revision: "2c254b3b11a4dbb82395f016886b557201dad130"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd4b41210dbcf5a6ffef5c4290ee15323dbe03b9fc79d80d9511e6900f699a6b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4ab7b4f9ebd51d78882c0864ef03386060152690b8712b1b6153d5995e785430"
    sha256 cellar: :any_skip_relocation, monterey:       "3bf2f015ff3055d27aac8cd834f946c6ab357bc7bbd4a7f6c910a90473b6ae88"
    sha256 cellar: :any_skip_relocation, big_sur:        "d951f0550f2f650e96b642e9fccb9722116098e07c7561075adeeb674698e3d0"
    sha256 cellar: :any_skip_relocation, catalina:       "5010820eb8e638d588eccfe8a7de119326ed999ea63e4fc748a178ffa9bf8895"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "315bc18c788eae0d1c8498446c75949c56c95c8b9570b702606356efa9237c71"
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
