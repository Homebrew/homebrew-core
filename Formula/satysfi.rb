class Satysfi < Formula
  desc "Statically-typed, functional typesetting system"
  homepage "https://github.com/gfngfn/SATySFi"
  url "https://github.com/gfngfn/SATySFi/archive/v0.0.2.tar.gz"
  sha256 "91b98654a99d8d13028d4c7334efa9d8cc792949b9ad1be5ec8b4cbacfaea732"

  depends_on "ocaml" => :build
  depends_on "opam" => :build

  def install
    mktemp do
      opamroot = Pathname.pwd/"opamroot"
      opamroot.mkpath
      ENV["OPAMROOT"] = opamroot
      ENV["OPAMYES"] = "1"
      system "opam", "init", "--no-setup"
      system "opam", "config", "exec", "--", "opam", "repository", "add", "satysfi-external", "https://github.com/gfngfn/satysfi-external-repo.git"
      system "opam", "config", "exec", "--", "opam", "pin", "add", "-n", "satysfi", buildpath
      system "opam", "config", "exec", "--", "opam", "install", "satysfi", "--deps-only"
      system "opam", "config", "exec", "--", "make", "-C", buildpath, "PREFIX=#{prefix}"
    end
    system "make", "lib"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_equal "! [Error] no input file designation.\n", shell_output("#{bin}/satysfi 2>&1", 1)
  end
end
