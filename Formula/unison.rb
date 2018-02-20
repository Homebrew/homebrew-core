class Unison < Formula
  desc "File synchronization tool for OSX"
  homepage "https://www.cis.upenn.edu/~bcpierce/unison/"
  url "https://github.com/bcpierce00/unison/archive/v2.48.15v4.tar.gz"
  version "2.48.15"
  sha256 "f8c7e982634bbe1ed6510fe5b36b6c5c55c06caefddafdd9edc08812305fdeec"

  bottle do
    cellar :any_skip_relocation
    sha256 "3e1c9260e9bdf7e7f3074cfee35d9068a3389c8fcda8556613419866ae5f928a" => :high_sierra
    sha256 "51b6a7abef991785f2b6d29dca9be3f7b17ea2261de4c8dded481d899c562a09" => :sierra
    sha256 "3bf2bc0ead48c846e631457f4451184fa45f70c4971cd53a47e35f5a5ee43f41" => :el_capitan
    sha256 "271bd5cd412997594e7ddfc7afad177c48e4f20fecc88cc4dbf828ccdf3f7385" => :yosemite
  end

  depends_on "ocaml" => :build

  def install
    ENV.deparallelize
    ENV.delete "CFLAGS" # ocamlopt reads CFLAGS but doesn't understand common options
    ENV.delete "NAME" # https://github.com/Homebrew/homebrew/issues/28642
    system "make", "src/mkProjectInfo"
    system "make", "UISTYLE=text"
    bin.install "src/unison"
    prefix.install_metafiles "src"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/unison -version")
  end
end
