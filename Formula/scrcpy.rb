class Scrcpy < Formula
  desc "Display and control your Android device"
  homepage "https://github.com/Genymobile/scrcpy"
  url "https://github.com/Genymobile/scrcpy/archive/v1.17.tar.gz"
  sha256 "c16f1fe1789290d0c7dd3a2778f33d6dc6347ffe3e78e64127b85eda52420d7f"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 "35b09818c9bf3d9e11b9894b28dc3333a5395a347932a019c773e21878452bc2" => :big_sur
    sha256 "cd3bce189328659edc3b9a0fcc11274c12d75ac96696e42cacb042c400fd6448" => :arm64_big_sur
    sha256 "940fbcda8626585ae3e48e8d5d9edfc4efe85b149eda28a0ea40d99c9caa5379" => :catalina
    sha256 "ee046917f0fd4ed6f53a162c353ab4d4ab2c27fc10f243d56436a798dafa66ce" => :mojave
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
