class Unison < Formula
  desc "File synchronization tool for OSX"
  homepage "https://www.cis.upenn.edu/~bcpierce/unison/"
  url "https://www.seas.upenn.edu/~bcpierce/unison//download/releases/stable/unison-2.48.4.tar.gz"
  sha256 "30aa53cd671d673580104f04be3cf81ac1e20a2e8baaf7274498739d59e99de8"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "51b6a7abef991785f2b6d29dca9be3f7b17ea2261de4c8dded481d899c562a09" => :sierra
    sha256 "3bf2bc0ead48c846e631457f4451184fa45f70c4971cd53a47e35f5a5ee43f41" => :el_capitan
    sha256 "271bd5cd412997594e7ddfc7afad177c48e4f20fecc88cc4dbf828ccdf3f7385" => :yosemite
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
