class Verovio < Formula
  desc "Command-line MEI music notation engraver"
  homepage "https://www.verovio.org"
  url "https://github.com/rism-digital/verovio/archive/refs/tags/version-5.2.0.tar.gz"
  sha256 "e1de4e0af9d8a19daaad0ac530764a418fa2b15920c5cf00d9c8c8b6d46d0790"
  license "LGPL-3.0-only"
  head "https://github.com/rism-digital/verovio.git", branch: "develop"

  bottle do
    sha256 arm64_sequoia: "296ef951a1958de9cce7f46b31abb4b7b579401a24bca0c6d85ab211814a9246"
    sha256 arm64_sonoma:  "787734091de62bfcc098d156b389a2665ee16d7c50518fb78ff8018280553f6f"
    sha256 arm64_ventura: "12c070c7f0298fbcec73022fdf7b41066a4f4053f3fc47e23da286eca5836f77"
    sha256 sonoma:        "ab5785deaab76ee197493865bcbb5e9180f9d0786225b82caad98a61b23ea8c5"
    sha256 ventura:       "e12265bf1c0540bb659b25d26686a85db0a3996b95ef5058cbc8f66d4c16fc54"
    sha256 arm64_linux:   "0edb045b79a9ebf9f10e138564f5bd7a6b9a00278131cdf9b8d08c8ebc24189c"
    sha256 x86_64_linux:  "670d42e80e46cf1409d21b92e9af8bf07acec7720a3a1cdc9ce52225de4f6da2"
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
    assert_path_exists testpath/"output.svg"
  end
end
