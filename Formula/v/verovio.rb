class Verovio < Formula
  desc "Command-line MEI music notation engraver"
  homepage "https://www.verovio.org"
  url "https://github.com/rism-digital/verovio/archive/refs/tags/version-5.6.0.tar.gz"
  sha256 "caea6c2d0b127bf7c6352f98c1174d2513498d06a1f6e0269b075e87f9333f39"
  license "LGPL-3.0-only"
  head "https://github.com/rism-digital/verovio.git", branch: "develop"

  bottle do
    sha256 arm64_tahoe:   "76f2e2f51492fdea5b960f32b50e4500c945faf68e1351d8637517fd9eda0ffe"
    sha256 arm64_sequoia: "dd2a429ef3cd34dee429c48088e345580b35058cde2e7434c5071ee706c730b0"
    sha256 arm64_sonoma:  "7a8d0c0df488d46f86a43c04db91aa7a58f2ef6938dc2ca2d40c9a80e0c4f7c9"
    sha256 arm64_ventura: "616407346dd6c98b6242be33f322ae9b8569f0fe0a0d9f331596def7219fb777"
    sha256 sonoma:        "449750a1cc9ea583aa34e8121aa6762f1cf4f7ce7e34cf06120e7d3b2298c60e"
    sha256 ventura:       "24f75ac1a8aa45ff8945fa2f0562812d16c20e526a2e7b08318ae174c7d08142"
    sha256 arm64_linux:   "f349d21d2a340ce6d611198539bf43ecf419ff8937e5e372551ad0b8b99bab5e"
    sha256 x86_64_linux:  "c5488f3ec6134eb7ff4caa71b6ecb0cf6c9481e804d1ed939ab8fc9af4b985db"
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
