class Spim < Formula
  desc "MIPS32 simulator"
  homepage "https://spimsimulator.sourceforge.io/"
  # No source code tarball exists
  url "https://svn.code.sf.net/p/spimsimulator/code", revision: "764"
  version "9.1.24"
  license "BSD-3-Clause"
  head "https://svn.code.sf.net/p/spimsimulator/code/"

  bottle do
    sha256                               arm64_ventura:  "8988a6ebd91f653a51334b91c6994614111ea7b22f947096c4e7e733308f7acf"
    sha256                               arm64_monterey: "06f1e5eafb737ed027b4eb7e46046cf2d31766cce568e10e2f8516253fb016ba"
    sha256                               arm64_big_sur:  "2adbe0458d654dd7fee2950dbbf0d208560a2727b11c4424029440e8a9e427e6"
    sha256                               ventura:        "1e8beca0f9b599bd1f265bfd9efd809af4eeb866cc1ac6129854ae460bc818b6"
    sha256                               monterey:       "933efdf418c0df8d5be8b6a87692fdd5a3452158a39435af31a36e8fe8e2ad02"
    sha256 cellar: :any_skip_relocation, big_sur:        "965617046b995f3e27f9c271880b4750d7dfb4d9eb9a665028b23f0ceb47a934"
    sha256                               x86_64_linux:   "e0360ac85fb93780c8cf1833800f8308b4df1c0863cfdf1c17692bb8bd1291c5"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    bin.mkpath
    cd "spim" do
      system "make", "EXCEPTION_DIR=#{share}"
      system "make", "install", "BIN_DIR=#{bin}",
                                "EXCEPTION_DIR=#{share}",
                                "MAN_DIR=#{man1}"
    end
  end

  test do
    assert_match "__start", pipe_output("#{bin}/spim", "print_symbols")
  end
end
