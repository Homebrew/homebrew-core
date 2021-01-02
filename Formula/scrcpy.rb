class Scrcpy < Formula
  desc "Display and control your Android device"
  homepage "https://github.com/Genymobile/scrcpy"
  url "https://github.com/Genymobile/scrcpy/archive/v1.17.tar.gz"
  sha256 "c16f1fe1789290d0c7dd3a2778f33d6dc6347ffe3e78e64127b85eda52420d7f"
  license "Apache-2.0"

  bottle do
    sha256 "c9658d00be68ecb6e0a4375a94d241f0f9499bf1495cf5713c61a5b6dd238de4" => :big_sur
    sha256 "c05855034ebaa61161ebf76fe13a47718e75b3809d617b0b5de09145bc14534d" => :arm64_big_sur
    sha256 "e6201c5231f70f2a2ea894e5103fc3de4ac6ecd3646898642346dea3973b5943" => :catalina
    sha256 "b0d097de2bbec45803d193a4e7f49245ba97e30ef3a23b4f68a8dc38756847e9" => :mojave
    sha256 "67b0df2cfc95417ce5f300229fb14f84e20003f409bda70e76a8e75fa51c9df5" => :high_sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "sdl2"

  resource "prebuilt-server" do
    url "https://github.com/Genymobile/scrcpy/releases/download/v1.17/scrcpy-server-v1.17"
    sha256 "11b5ad2d1bc9b9730fb7254a78efd71a8ff46b1938ff468e47a21b653a1b6725"
  end

  # Fix build on Xcode 12 (https://github.com/Genymobile/scrcpy/issues/1726)
  # Remove in the next release
  patch do
    url "https://github.com/Genymobile/scrcpy/commit/bd9f656933e79f7b21b42993f8a70a761ab47226.patch?full_index=1"
    sha256 "3ab1c2d4b9cc38fe94ae24c49c74b4008a36ffb8079442545feeffa5d3448540"
  end

  def install
    r = resource("prebuilt-server")
    r.fetch
    cp r.cached_download, buildpath/"prebuilt-server.jar"

    mkdir "build" do
      system "meson", *std_meson_args,
                      "-Dprebuilt_server=#{buildpath}/prebuilt-server.jar",
                      ".."

      system "ninja", "install"
    end
  end

  def caveats
    <<~EOS
      At runtime, adb must be accessible from your PATH.

      You can install adb from Homebrew Cask:
        brew install --cask android-platform-tools
    EOS
  end

  test do
    fakeadb = (testpath/"fakeadb.sh")

    # When running, scrcpy calls adb three times:
    #  - adb push ... (to push scrcpy-server.jar)
    #  - adb reverse ... tcp:PORT ...
    #  - adb shell ...
    # However, exiting on $1 = shell didn't work properly, so instead
    # fakeadb exits on $1 = reverse

    fakeadb.write <<~EOS
      #!/bin/sh
      echo $@ >> #{testpath/"fakeadb.log"}

      if [ "$1" = "reverse" ]; then
        exit 42
      fi
    EOS

    fakeadb.chmod 0755
    ENV["ADB"] = fakeadb

    # It's expected to fail after adb reverse step because fakeadb exits
    # with code 42
    out = shell_output("#{bin}/scrcpy -p 1337 2>&1", 1)
    assert_match(/ 42/, out)

    log_content = File.read(testpath/"fakeadb.log")

    # Check that it used port we've specified
    assert_match(/tcp:1337/, log_content)

    # Check that it tried to push something from its prefix
    assert_match(/push #{prefix}/, log_content)
  end
end
