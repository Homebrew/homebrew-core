class Stanc3 < Formula
  desc "Stan transpiler"
  homepage "https://github.com/stan-dev/stanc3"
  # git is needed for dune subst
  # TODO: Update `ocaml@4` dependency to `ocaml` on next release as OCaml 4.14 PR
  # also adds support for OCaml 5: https://github.com/stan-dev/stanc3/pull/1366
  url "https://github.com/stan-dev/stanc3.git",
      tag:      "v2.32.2",
      revision: "bcbf83c52c76018ce4a6cd86233de1601ddf9422"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9d35edd630e73ccbb97e008eaa06c6be9843d345a6fdd332323092dd6a94d68e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "455d22e5b4940c5e82a16bf1b318e986550613c6853a0c11401f657366c0b323"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "87ab3722ebe250a0df5ee5efd2b03ae2a86916165e2c4ba6ec0e603c4b56dbf4"
    sha256 cellar: :any_skip_relocation, sonoma:         "1afd613896f2c410c59791e3424ad26a83d6a2894dc6d9a3cae17bc608432b3a"
    sha256 cellar: :any_skip_relocation, ventura:        "6a04a68759042d72aa8873097aaf549c00161c5918988ce12e9285e65746388f"
    sha256 cellar: :any_skip_relocation, monterey:       "86c34cf28af87e139589fae994068e59f47ec8f7dc2526ec7d97b635800d4fc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc126261729eb66168ad84757e0c90f7c53dd95c87546d88de9096aad2815733"
  end

  depends_on "ocaml@4" => :build
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
