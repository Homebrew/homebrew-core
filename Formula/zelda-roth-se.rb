class ZeldaRothSe < Formula
  desc "Zelda Return of the Hylian SE"
  homepage "https://www.solarus-games.org/en/games/the-legend-of-zelda-return-of-the-hylian-se"
  url "https://gitlab.com/solarus-games/zelda-roth-se/-/archive/v1.2.1/zelda-roth-se-v1.2.1.tar.bz2"
  sha256 "1cff44fe97eab1327a0c0d11107ca10ea983a652c4780487f00f2660a6ab23c0"
  head "https://gitlab.com/solarus-games/zelda-roth-se.git", branch: "dev"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, big_sur:     "28b1bd5308092389db177a9b277a29f1da892c1a4a71dd9b12e483a045e52808"
    sha256 cellar: :any_skip_relocation, catalina:    "1531cd6fc89cca4cc08287e569cdd8b86e41a52bb8c66fb10f6a74bb5006bc24"
    sha256 cellar: :any_skip_relocation, mojave:      "b0451d1eb512280f9dcb2c6057188cbe02e9b2c71fbf337ac463a4e284ba1987"
    sha256 cellar: :any_skip_relocation, high_sierra: "dcf7800dd6c2e8798abb867733a79acda20e3ce7745b7d489eeac3050a7bf829"
  end

  depends_on "cmake" => :build
  depends_on "solarus"

  def install
    system "cmake", ".", *std_cmake_args, "-DSOLARUS_INSTALL_DATADIR=#{share}"
    system "make", "install"
  end

  test do
    system Formula["solarus"].bin/"solarus-run", "-help"
    system "/usr/bin/unzip", share/"zelda_roth_se/data.solarus"
  end
end
