class Zint < Formula
  desc "Barcode encoding library supporting over 50 symbologies"
  homepage "https://www.zint.org.uk/"
  url "https://downloads.sourceforge.net/project/zint/zint/2.11.0/zint-2.11.0-src.tar.gz"
  sha256 "557e09d93e7a63401a12c7616c012a9d900ef281def492d5e054d561676868b6"
  license "GPL-3.0-or-later"
  head "https://git.code.sf.net/p/zint/code.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{url=.*?/zint[._-]v?(\d+(?:\.\d+)+)(?:-src)?\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0b93247f9bbb4c70cf3816b08b67b5bf50e2fb92919c877907245caf6d980714"
    sha256 cellar: :any,                 arm64_big_sur:  "f76d1606ece2958253a7a390ff454a345d781518f6f80d844a0409df35f6bf5f"
    sha256 cellar: :any,                 monterey:       "1865bd86c36915097ee5206c20ee53053623d8d40fb481d819b9bb606bd4ad96"
    sha256 cellar: :any,                 big_sur:        "195c2cce73ec7cfa15ac935e1709a976c91d3f4b173ccec8f0f22d169a1162f7"
    sha256 cellar: :any,                 catalina:       "22cad558d7e8a6b1aa76d6b5980aab0f49ebf125623bd430a8d1579294d20da4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fa96e211434dda9e0431072f8b15abb19b1c69be35705dbdcd680fdd14c3a64"
  end

  depends_on "cmake" => :build
  depends_on "libpng"

  def install
    # Sandbox fix: install FindZint.cmake in zint's prefix, not cmake's.
    inreplace "CMakeLists.txt", "${CMAKE_ROOT}", "#{share}/cmake"

    mkdir "zint-build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/zint", "-o", "test-zing.png", "-d", "This Text"
  end
end
