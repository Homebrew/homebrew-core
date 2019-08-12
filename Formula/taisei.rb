class Taisei < Formula
  desc "Clone of Tōhō Project shoot-em-up games"
  homepage "https://taisei-project.org/"
  url "https://github.com/taisei-project/taisei.git",
      :tag      => "v1.3",
      :revision => "f8ef67224f47e85f4095e32736dc21e0d46ae5b7"

  bottle do
    sha256 "81286c197a97f979323bcded1b9ed5756b31c35e36381e6011a87aa2ffd73264" => :mojave
    sha256 "97c3b7de6e84bbd476bd006bae3561814d9c35c3e7961d3750a1df0ad16d9f4a" => :high_sierra
    sha256 "97afc62541cd893e05a922ae4e36bd456e1cb2746a3d46503569916cd20a16da" => :sierra
  end

  # Yes, these are all build deps; the game copies them into the app bundle,
  # and doesn't require the Homebrew versions at runtime.
  depends_on "freetype" => :build
  depends_on "libpng" => :build
  depends_on "libzip" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "openssl@1.1" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
  depends_on "sdl2" => :build
  depends_on "sdl2_mixer" => :build
  depends_on "sdl2_ttf" => :build

  def install
    mkdir "build" do
      system "meson", "--prefix=#{prefix}", "-Ddocs=false", ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  def caveats
    "Sound may not work."
  end

  test do
    output = shell_output("#{prefix}/Taisei.app/Contents/MacOS/Taisei -h", 1)
    assert_match "Tōhō Project", output
  end
end
