class Wemux < Formula
  desc "Enhances tmux's to provide multiuser terminal multiplexing"
  homepage "https://github.com/zolrath/wemux"
  url "https://github.com/zolrath/wemux/archive/v3.2.0.tar.gz"
  sha256 "8de6607df116b86e2efddfe3740fc5eef002674e551668e5dde23e21b469b06c"
  head "https://github.com/zolrath/wemux.git"

  bottle do
    rebuild 2
    sha256 "d2abdfef10f58397bd2432229ad301f75f1f2f615aca6151165c93822ed208be" => :mojave
    sha256 "4da7fcb0ac46c071491e9c8a3946ae4515414b64a5513c75acde7d71650daa4d" => :high_sierra
    sha256 "4da7fcb0ac46c071491e9c8a3946ae4515414b64a5513c75acde7d71650daa4d" => :sierra
    sha256 "4da7fcb0ac46c071491e9c8a3946ae4515414b64a5513c75acde7d71650daa4d" => :el_capitan
  end

  depends_on "tmux"

  def install
    inreplace "wemux", "/usr/local/etc", etc
    bin.install "wemux"
    man1.install "man/wemux.1"

    inreplace "wemux.conf.example", "change_this", ENV["USER"]
    etc.install "wemux.conf.example" => "wemux.conf"
  end

  def caveats; <<~EOS
    Your current user account has been automatically added as a wemux host.

    To give a user the ability to host wemux sessions add them to the
    host_list array in:
      #{etc}/wemux.conf

    Either edit the file in your text editor of choice or run `wemux conf` to
    open the file in your $EDITOR.
  EOS
  end

  test do
    system "#{bin}/wemux", "help"
  end
end
