class Taisei < Formula
  desc "Clone of Tōhō Project shoot-em-up games"
  homepage "https://taisei-project.org/"
  url "https://github.com/taisei-project/taisei.git",
      :tag      => "v1.3",
      :revision => "f8ef67224f47e85f4095e32736dc21e0d46ae5b7"

  bottle do
    sha256 "5a63d77e6ba51f8907f1d6a08ca6fc3c94b7f4317afd746c91f0c8011d767c20" => :mojave
    sha256 "162eb10eaf78191aeb474f75095cb35b5840dd4b4ad1e0452ec65ab19590cf80" => :high_sierra
    sha256 "0065ca15927c95e455dd3a42c4cc1dfcb9365069c914a8d1bffca11e41dbde00" => :sierra
    sha256 "b9eae75e261940cba3bf33aec8fea1904c6de4648a0dea1f32f517289e0d9a1d" => :el_capitan
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
