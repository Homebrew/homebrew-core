class Unison < Formula
  desc "File synchronization tool for OSX"
  homepage "https://www.cis.upenn.edu/~bcpierce/unison/"
  url "https://github.com/bcpierce00/unison/archive/v2.51.2.tar.gz"
  sha256 "a2efcbeab651be6df69cc9b253011a07955ecb91fb407a219719451197849d5e"

  bottle do
    cellar :any_skip_relocation
    sha256 "55a361bda2f5a43073508d25702eea6b16470f74619e4a6d1058f7fc89f901e5" => :mojave
    sha256 "1622a673b2bc8ef6d00dd754c26cfd3d5f737ed1dc48a46bbce486fa0f766181" => :high_sierra
    sha256 "fd00605490100ec224f5d86a79da341ce639e1d0772fb48cc133672d1bc2a812" => :sierra
    sha256 "53c945e143961a5d158a36980664d5be7153b84074bfa4220eee2db35404b7d3" => :el_capitan
  end

  depends_on "ocaml" => :build

  def install
    ENV.deparallelize
    ENV.delete "CFLAGS" # ocamlopt reads CFLAGS but doesn't understand common options
    ENV.delete "NAME" # https://github.com/Homebrew/homebrew/issues/28642
    system "make", "UISTYLE=text"
    bin.install "src/unison"
    prefix.install_metafiles "src"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/unison -version")
  end
end
