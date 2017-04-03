class UnisonAT240 < Formula
  desc "Unison file synchronizer"
  homepage "https://www.cis.upenn.edu/~bcpierce/unison/"
  url "https://www.seas.upenn.edu/~bcpierce/unison/download/releases/unison-2.40.128/unison-2.40.128.tar.gz"
  sha256 "5a1ea828786b9602f2a42c2167c9e7643aba2c1e20066be7ce46de4779a5ca54"

  keg_only :versioned_formula

  depends_on "ocaml" => :build
  depends_on "opam" => :build

  def install
    ENV["OPAMYES"] = "1"
    ENV["OPAMROOT"] = Pathname.pwd/"opamroot"
    (Pathname.pwd/"opamroot").mkpath

    system "opam", "init", "--no-setup"
    inreplace "opamroot/compilers/4.02.3/4.02.3/4.02.3.comp",
      '["./configure"', '["./configure" "-no-graph"'
    system "opam", "switch", "4.02.3"

    ENV.deparallelize
    ENV.delete "CFLAGS" # ocamlopt reads CFLAGS but doesn't understand common options
    ENV.delete "NAME" # https://github.com/Homebrew/homebrew/issues/28642
    system "opam", "config", "exec", "--", "make", "./mkProjectInfo"
    system "opam", "config", "exec", "--", "make", "UISTYLE=text"
    bin.install "unison"
  end

  test do
    system bin/"unison", "-version"
  end
end
