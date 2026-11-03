class Verovio < Formula
  desc "Command-line MEI music notation engraver"
  homepage "https://www.verovio.org"
  url "https://github.com/rism-digital/verovio/archive/refs/tags/version-6.4.1.tar.gz"
  sha256 "401e555ab19825d6843f662c8d4e40a310f0f63f349461d24b685d6e32209fbc"
  license "LGPL-3.0-only"
  head "https://github.com/rism-digital/verovio.git", branch: "develop"

  bottle do
    sha256 arm64_golden_gate: "323365af4889c6e257ea3f4b5a7951846ed685d3735812e0f982cabe91b27681"
    sha256 arm64_tahoe:       "201279ca4283c16204aecff72683909a698107782315bbe5f4272b7bd13d9ae5"
    sha256 arm64_sequoia:     "29a5647a73693ffe96c8c937f63b01e4947f7856c8c0f16804e2c31e2c9aa596"
    sha256 arm64_linux:       "5cc2a592c805b11b36be5b31c62fb96f1fdf24c480a807fbc85be7f74f346de3"
    sha256 x86_64_linux:      "89ba30e9dae47bad2520ae6cc342be9e926840db058e7ba32c8c02706d9d7772"
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
