class Verovio < Formula
  desc "Command-line MEI music notation engraver"
  homepage "https://www.verovio.org"
  url "https://github.com/rism-digital/verovio/archive/refs/tags/version-6.0.1.tar.gz"
  sha256 "e2025eb4ea4462db8a71d79e10ea5bd3ebc4c148e8f95d711505c52a73ad76e9"
  license "LGPL-3.0-only"
  head "https://github.com/rism-digital/verovio.git", branch: "develop"

  bottle do
    sha256 arm64_tahoe:   "aadb6c87539d12cbfd0959b6b8c1cdb4be64581b5f4e87da1acc25e2b661c679"
    sha256 arm64_sequoia: "1c1f9238ec331a087f09a86e1cd2e0cfe1cd69990040bb289008ef12145350e7"
    sha256 arm64_sonoma:  "f46081962ef0228b4c675dbda330b3f65c733dde801b201358d9f9cd1fd803ed"
    sha256 sonoma:        "112664273a397282700ecdd0890fa324b0b5e6c0fc49f7622fd7bc0e25d63c8c"
    sha256 arm64_linux:   "98f983780f1265952a2659327ef681f764cf9000eaba91eb28c2571d8e8fe61c"
    sha256 x86_64_linux:  "4c098961e5702827cf587d776504261e364b4b7e7f11ee735e20ded7ebff48be"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", "./cmake", "-B", "tools", *std_cmake_args
    system "cmake", "--build", "tools"
    system "cmake", "--install", "tools"
  end

  test do
    resource "homebrew-testdata" do
      url "https://www.verovio.org/examples/downloads/Ahle_Jesu_meines_Herzens_Freud.mei"
      sha256 "79e6e062f7f0300e8f0f4364c4661835a0baffc3c1468504a555a5b3f9777cc9"
    end

    system bin/"verovio", "--version"
    resource("homebrew-testdata").stage do
      shell_output("#{bin}/verovio Ahle_Jesu_meines_Herzens_Freud.mei -o #{testpath}/output.svg")
    end
    assert_path_exists testpath/"output.svg"
  end
end
