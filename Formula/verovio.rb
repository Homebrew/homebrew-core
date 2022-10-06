class Verovio < Formula
  desc "Command-line MEI music notation engraver"
  homepage "https://www.verovio.org"
  url "https://github.com/rism-digital/verovio/archive/refs/tags/version-3.12.1.tar.gz"
  sha256 "7f69b39e25f9662185906c9da495437e09539a520b9dda80f1bef818e905881b"
  license "LGPL-3.0-only"
  head "https://github.com/rism-digital/verovio.git", branch: "develop"

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", "./cmake", "-B", "tools", *std_cmake_args
    system "cmake", "--build", "tools"
    system "cmake", "--install", "tools"
  end

  resource("testdata") do
    url "https://www.verovio.org/examples/downloads/Ahle_Jesu_meines_Herzens_Freud.mei"
    sha256 "d08735930f5591b6d86250ed93795af156b8d0297ed38256fed84dc9739ed381"
  end

  test do
    system bin/"verovio", "--version"
    resource("testdata").stage do
      shell_output("#{bin}/verovio Ahle_Jesu_meines_Herzens_Freud.mei -o #{testpath}/output.svg")
      assert_predicate testpath/"output.svg", :exist?
    end
  end
end
