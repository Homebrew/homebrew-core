class Wemux < Formula
  desc "Enhances tmux's to provide multiuser terminal multiplexing"
  homepage "https://github.com/zolrath/wemux"
  url "https://github.com/zolrath/wemux/archive/v3.2.0.tar.gz"
  sha256 "8de6607df116b86e2efddfe3740fc5eef002674e551668e5dde23e21b469b06c"

  head "https://github.com/zolrath/wemux.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "8f4b4487c79752dd628e4dcbadf862520da5a6d4be677114528425b65e5f130c" => :sierra
    sha256 "882a3d58408b8a3f1d8d8701f23d96e2b73ea2a4cfe3ae60d6c9fa10d62a0681" => :el_capitan
    sha256 "413d8099b66ae483fdedfecc79bcff2116d9ea579a23c5c4d3b4c24ec68db6cb" => :yosemite
    sha256 "37be489fca544a7add785cfa20c419e3a313c2a8b3e1ba8ee611c1f7a1677467" => :mavericks
  end

  depends_on "tmux"

  def install
    inreplace "wemux", "/usr/local/etc", etc
    bin.install "wemux"
    man1.install "man/wemux.1"

    inreplace "wemux.conf.example", "change_this", ENV["USER"]
    etc.install "wemux.conf.example" => "wemux.conf"
  end

  def caveats; <<-EOS.undent
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
