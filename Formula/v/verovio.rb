class Verovio < Formula
  desc "Command-line MEI music notation engraver"
  homepage "https://www.verovio.org"
  url "https://github.com/rism-digital/verovio/archive/refs/tags/version-6.4.1.tar.gz"
  sha256 "401e555ab19825d6843f662c8d4e40a310f0f63f349461d24b685d6e32209fbc"
  license "LGPL-3.0-only"
  head "https://github.com/rism-digital/verovio.git", branch: "develop"

  bottle do
    sha256 arm64_golden_gate: "ae2816b9f4c250546f067f7b4bd973b09be0b4afd481408c3be9c06cdb9a6de0"
    sha256 arm64_tahoe:       "9a47d2e5447c3f951328c0e4ef74a40f56399ce06c2dfda547daedcb5fac7abc"
    sha256 arm64_sequoia:     "dec57758e27e43983aec7b8b9e41ecba298d33c8c7761d9c6f434078aa204b36"
    sha256 arm64_linux:       "2f9f3a152642f00a3ba49b7f384091c2cebfa496c8bcdb93de99cc9e55c196a6"
    sha256 x86_64_linux:      "177fdff2b55ae12ee0d7967e6173497538c00f9bc36f25e57468012a9fea663e"
  end

  depends_on "cmake" => :build

  resource "homebrew-testdata", :test do
    url "https://www.verovio.org/examples/downloads/Ahle_Jesu_meines_Herzens_Freud.mei"
    sha256 "79e6e062f7f0300e8f0f4364c4661835a0baffc3c1468504a555a5b3f9777cc9"
  end

  allow_network_access! :test

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
    assert_path_exists testpath/"output.svg"
  end
end
