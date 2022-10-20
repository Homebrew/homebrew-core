class Verovio < Formula
  desc "Command-line MEI music notation engraver"
  homepage "https://www.verovio.org"
  url "https://github.com/rism-digital/verovio/archive/refs/tags/version-3.12.1.tar.gz"
  sha256 "7f69b39e25f9662185906c9da495437e09539a520b9dda80f1bef818e905881b"
  license "LGPL-3.0-only"
  head "https://github.com/rism-digital/verovio.git", branch: "develop"

  bottle do
    sha256                               arm64_monterey: "7c880b3259b73ee88c47ebf556dc41bad1865e9a3590543fde779d016810cb98"
    sha256                               arm64_big_sur:  "cc10c1838a0744b2776fd81348833060046094f92ec24f3e1af37b9e0aaefa43"
    sha256                               monterey:       "696682c28c431eb666cae0f3f5fd717132da6ee8f19c817dd20b27e76a73e663"
    sha256                               big_sur:        "52c06c34e2bda89201a67006762ba26d55c4290034b1d6e39eb86d551b640f4a"
    sha256                               catalina:       "6f03e4e11db0c40586cf5d218c8ca523a6a62e1814c399d9a1dbfb38dd7097e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af085d4c96f334c7951b6d78e346c82c021a3bbf18e4c399edaf1730079ef716"
  end

  depends_on "cmake" => :build

  resource "homebrew-testdata" do
    url "https://www.verovio.org/examples/downloads/Ahle_Jesu_meines_Herzens_Freud.mei"
    sha256 "79e6e062f7f0300e8f0f4364c4661835a0baffc3c1468504a555a5b3f9777cc9"
  end

  def install
    system "cmake", "-S", "./cmake", "-B", "tools", *std_cmake_args
    system "cmake", "--build", "tools"
    system "cmake", "--install", "tools"
  end

  test do
    system bin/"verovio", "--version"
    resource("homebrew-testdata").stage do
      shell_output("#{bin}/verovio Ahle_Jesu_meines_Herzens_Freud.mei -o #{testpath}/output.svg")
    end
    assert_predicate testpath/"output.svg", :exist?
  end
end
