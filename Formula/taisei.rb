class Taisei < Formula
  desc "Clone of Touhou Project shoot-em-up games"
  homepage "https://taisei-project.org/"
  url "https://github.com/taisei-project/taisei.git",
      :tag => "v1.2",
      :revision => "46fb0f894ad269528ac7fda533c7994eddd9b758"

  bottle do
    sha256 "d693cb55f630f29a41d1182179cf019f2fd81593246cd5cd3c5769bcc4d49324" => :high_sierra
    sha256 "4e61442d7f6031f558e898c5eb28fcc4e7ccf6811d523e989859131087252a14" => :sierra
    sha256 "d9494fdf13cdfdfff4a7107cb93821e39d9079e86f660ce63b15f5ed37df8ce6" => :el_capitan
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "libpng"
  depends_on "libzip"
  depends_on "python3"
  depends_on "sdl2"
  depends_on "sdl2_mixer"
  depends_on "sdl2_ttf"

  def install
    mkdir "build" do
      system "meson", "--prefix=#{prefix}", "-Ddocs=false", "-Dmacos_bundle=false", ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  def caveats
    "Sound may not work."
  end

  test do
    output = shell_output("#{bin}/taisei -h", 1)
    assert_match "Touhou clone", output
  end
end
