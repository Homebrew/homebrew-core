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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8d5f37a394a5648cb71e93dc693b2ece5c8199b5f12b8fc67cca3f7914f385cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "92711699de011d8d0e2d1f3c9070a68359d8532bb839c3bfd85dd19d2e0757ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7cfef591789f94cc42a791f525e152a66df28f38192bfbae89d02b38b716026e"
    sha256 cellar: :any_skip_relocation, sonoma:         "0129492246548c760cd4e443b90f332bb21a981e1c8d5b1837ae182fe2cfbf69"
    sha256 cellar: :any_skip_relocation, ventura:        "f738cab3f67f135b7d8ddad036afa0d197086aa0d6964aac385e3706aece60a6"
    sha256 cellar: :any_skip_relocation, monterey:       "10f98fb1d34c6a395d5922042f7d1aeeefcf2d1be5ecf691adc11daacdbfb1c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "653c73565c23ae031590a18bd3a9537bef7fff3f787450340e5332718d31de68"
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
