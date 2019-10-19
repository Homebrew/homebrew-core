class Ttf2eot < Formula
  desc "Convert TTF files to EOT"
  homepage "https://github.com/wget/ttf2eot"
  url "https://github.com/wget/ttf2eot/archive/v0.0.3.tar.gz"
  sha256 "f363c4f2841b6d0b0545b30462e3c202c687d002da3d5dec7e2b827a032a3a65"

  bottle do
    cellar :any_skip_relocation
    sha256 "05b1f397b4784a77f36a3d3138e812932db4419d8d03e0f0735e58591677e918" => :catalina
    sha256 "54d328636bcb7d9fe1e28bf46115f0b718fc9f4d8e18c48b39d5b2e87bb3930b" => :mojave
    sha256 "7b44ec925ee2bbeeaba775befc77c0c22f2f690ecd94edb72e471c631da80f43" => :high_sierra
    sha256 "26f40d7a58de2ee396fc04dd47c41e9b65640570fa1ca8b71134dd88e6e88c06" => :sierra
    sha256 "5fc89e642b7d51c0c7965d9a952d1b697f94b4ec16d7711ff37387979ce47f5d" => :el_capitan
  end

  def install
    system "make"
    bin.install "ttf2eot"
  end

  test do
    font_name = (MacOS.version >= :catalina) ? "Arial Unicode.ttf" : "Arial.ttf"
    cp "/Library/Fonts/#{font_name}", testpath
    system("#{bin}/ttf2eot < '#{font_name}' > Arial.eot")
    assert_predicate testpath/"Arial.eot", :exist?
  end
end
