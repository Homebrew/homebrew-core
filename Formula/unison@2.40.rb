class UnisonAT240 < Formula
  desc "Unison file synchronizer"
  homepage "https://www.cis.upenn.edu/~bcpierce/unison/"
  url "https://www.seas.upenn.edu/~bcpierce/unison/download/releases/unison-2.40.128/unison-2.40.128.tar.gz"
  sha256 "5a1ea828786b9602f2a42c2167c9e7643aba2c1e20066be7ce46de4779a5ca54"

  bottle do
    cellar :any_skip_relocation
    sha256 "76fa8dc81fbf5ab4fe19dbd96bc221095c0eb67550d68a6f74c9670c3abeaf29" => :sierra
    sha256 "6046281f4e119843646b8d2312f0b25824b4ec7c6c7857e35beb5a90b03dfcac" => :el_capitan
    sha256 "20893d19f048adccfd232a9bec3ccd96127cc6949f6cc0b4734397160641be81" => :yosemite
  end

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
