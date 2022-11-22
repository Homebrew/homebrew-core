class Stanc3 < Formula
  desc "Stan transpiler"
  homepage "https://github.com/stan-dev/stanc3"
  # git is needed for dune subst
  url "https://github.com/stan-dev/stanc3.git",
      tag:      "v2.31.0",
      revision: "554a2ab9aa2c1d3afbd450a93aa19a587d8ed5f1"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b15f1dc3e954473aa8568dfceb4fd4dc07ec47cff7e6fd43135520039e0c8653"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "866e9100eb80851e0af28ee3e9fca945e1077abc5b6d9a7fc663407f5cddb03a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fbe9f4dadd5549fb10a479b2c4288b39e2f78d20cbf1f978fca935c852acb6e1"
    sha256 cellar: :any_skip_relocation, ventura:        "8c7d917c01b2ba4b2c2dafc953a5f41ec08f4f98906205ec40304654bd57da90"
    sha256 cellar: :any_skip_relocation, monterey:       "b787b1138d0dc3ae0e0374e7a73931d0d0d412e11c1ed906e1b3c8e845780bb1"
    sha256 cellar: :any_skip_relocation, big_sur:        "a851b62a300f00fe97c52ba92e369b1f587cc7a40ff3e9a7a30e74fe271647db"
    sha256 cellar: :any_skip_relocation, catalina:       "9fe673c94fe2c1323ae1218aab6fad68d42a996afd5b20c10829f0d6eb2b3556"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5418bfff61951b04e00ffd6391106ebc8657fffe3cf4bfe24a737eeaee3d5cfb"
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
