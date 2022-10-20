class Unison < Formula
  desc "File synchronization tool for OSX"
  homepage "https://www.cis.upenn.edu/~bcpierce/unison/"
  url "https://github.com/bcpierce00/unison/archive/v2.52.1.tar.gz"
  sha256 "ff7d920e1b4ec0872df764130b82a515f6f21a361f31a67b39c3e3ea12bfda80"
  license "GPL-3.0-or-later"
  head "https://github.com/bcpierce00/unison.git", branch: "master"

  # The "latest" release on GitHub sometimes points to unstable versions (e.g.,
  # release candidates), so we check the Git tags instead.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45293fd4e83702a4d380e9de6b47d3f783921ff7d808e7210a065781fe1cf3a6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c3f2d8eee01742ac5684b99ebda2279e73e5bd13662432cb119deee550070cd2"
    sha256 cellar: :any_skip_relocation, monterey:       "cbedbc4e31e0ae5d79d9ad3c1488f5f3a837aa374c2f9491bfbb0bb6e4d5f370"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d18ef8e7f2847cbce44229fa59f07590ac2d56b2dac1c859d0ba7095932e59c"
    sha256 cellar: :any_skip_relocation, catalina:       "2b88be10c70130c6a9f0232b00976987fd8378c561dc86fe39805d989eaa28aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4364430843f28d8467531315922e607d8da2e05ed17199f30895e659c70d6f9e"
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
