class Unison < Formula
  desc "File synchronization tool for OSX"
  homepage "https://www.cis.upenn.edu/~bcpierce/unison/"
  url "https://www.seas.upenn.edu/~bcpierce/unison//download/releases/stable/unison-2.48.4.tar.gz"
  sha256 "30aa53cd671d673580104f04be3cf81ac1e20a2e8baaf7274498739d59e99de8"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "3253290c357c9740f02b289ecc9ef9b8124733a1f2d0bbbb52c22df58282c264" => :sierra
    sha256 "f6c266af01a145381c73d0ab5b89c480c9cb1770e08b0d8d88e514d19045afd0" => :el_capitan
    sha256 "55f770497c67900e508bb9478671e7148f4214694a09ad475e246529a64a3a3a" => :yosemite
    sha256 "fe26dcfa9763fe9ed89a2cca23f82ca11b0c9117a0d52758ef245d5f307304f5" => :mavericks
  end

  depends_on "ocaml" => :build

  def install
    ENV.deparallelize
    ENV.delete "CFLAGS" # ocamlopt reads CFLAGS but doesn't understand common options
    ENV.delete "NAME" # https://github.com/Homebrew/homebrew/issues/28642
    system "make", "./mkProjectInfo"
    system "make", "UISTYLE=text"
    bin.install "unison"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/unison -version")
  end
end
