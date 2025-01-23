class Verovio < Formula
  desc "Command-line MEI music notation engraver"
  homepage "https://www.verovio.org"
  url "https://github.com/rism-digital/verovio/archive/refs/tags/version-4.5.1.tar.gz"
  sha256 "ef088bdf3f68b95dc74e12dd7b5fdcbf35e70be33f07dc65f8f5902db76e8d5e"
  license "LGPL-3.0-only"
  head "https://github.com/rism-digital/verovio.git", branch: "develop"

  bottle do
    sha256 arm64_sequoia: "6076672f943ccebd0f7aac7805001aa9d4e7bcf65d359e9969860aaa98796de2"
    sha256 arm64_sonoma:  "4efe1058fd2c45d2b1749b8683a2734ffe6388deb8c311e69ca8637da36c987d"
    sha256 arm64_ventura: "291caa707fe635b104c24ef48f791f33008cbefb3ceb5c3b0a6a0bbe2e4461e8"
    sha256 sonoma:        "cf9cac00c664f3a57511857899512453ed4becda3684879e2f06809fbcaac234"
    sha256 ventura:       "9143a905311e96bb38beb55fba06d3018246c193a130449fc1177174cb103415"
    sha256 x86_64_linux:  "0ac976fbe1edb62069f5b07f15f177dfeb1e13c1271cc74cf28f195be6a0953d"
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
