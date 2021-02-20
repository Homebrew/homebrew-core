class Valabind < Formula
  desc "Vala bindings for radare, reverse engineering framework"
  homepage "https://github.com/radare/valabind"
  url "https://github.com/radare/valabind/archive/1.8.0.tar.gz"
  sha256 "3eba8c36c923eda932a95b8d0c16b7b30e8cdda442252431990436519cf87cdd"
  license "GPL-3.0-or-later"
  head "https://github.com/radare/valabind.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "2fb4393d61be4746bc3dca065d162dc664035200ee4b326f64ce8b02908a6cc3"
    sha256 cellar: :any, big_sur:       "cbaf377ea488bba4b372abe53eab42bdf84da7b93b00a827b847179477c59109"
    sha256 cellar: :any, catalina:      "6a33a391be8a6d352504ba407afa44bca868d9065fac979ed7139edcb8797fef"
    sha256 cellar: :any, mojave:        "4503f99bdf938276cbdbb8b5312f6b380a13cf8d653b88c02be1dfa880a2803c"
  end

  depends_on "pkg-config" => :build
  depends_on "swig"
  depends_on "vala"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"valabind", "--help"
  end
end
