class VideoCompare < Formula
  desc "Split screen video comparison tool using FFmpeg and SDL2"
  homepage "https://github.com/pixop/video-compare"
  url "https://github.com/pixop/video-compare/archive/refs/tags/20240114.tar.gz"
  sha256 "1cc9dc6a8cc2841ff1271f42c85a0bbe7ca8689b4b11760528f40fe88b17c114"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "070d21b56766b348f3e3b17c48df81a7fae3a29a09404aa9e9590ea967e8f618"
    sha256 cellar: :any,                 arm64_ventura:  "91610ace3e3fe96eecc449f25af3cead1e6cb16eb70a490dbb6c040f0badfdfb"
    sha256 cellar: :any,                 arm64_monterey: "20abe0bd268b54492376a3116807861c7bbc1397c01bbf188e4906b142d368e1"
    sha256 cellar: :any,                 sonoma:         "892e2fc93b9ec242a566986e53d56559a18c57aca36f3aae3412957241413d28"
    sha256 cellar: :any,                 ventura:        "4298233a138dc35800369c4b2910a8bcc09875764d6eb34be28dbd6b374cf914"
    sha256 cellar: :any,                 monterey:       "96e97440f243b638eb2ee8d866dc5827e4a15c0ae9a800832a3a51736cfd4273"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b60d4a27999954f4604eda9e7ae48efebe8767c54b7bf814488c12962c4da3ce"
  end

  depends_on "ffmpeg"
  depends_on "sdl2"
  depends_on "sdl2_ttf"

  def install
    system "make"
    bin.install "video-compare"
  end

  test do
    testvideo = test_fixtures("test.gif") # GIF is valid ffmpeg input format
    begin
      pid = fork do
        exec "#{bin}/video-compare", testvideo, testvideo
      end
      sleep 3
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
