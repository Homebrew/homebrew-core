class Xmodmap < Formula
  desc "Modify keymaps and pointer button mappings in X"
  homepage "https://gitlab.freedesktop.org/xorg/app/xmodmap"
  url "https://www.x.org/releases/individual/app/xmodmap-1.0.12.tar.xz"
  sha256 "fc54b9b5bbf2ae58ba8f9d42bd051c41c7438377400c42c17d7496d19e1bb3ce"
  license "MIT-open-group"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "bee38f85e975f72f62bc3e4045bddfd96ad344519354ad0bc43694c6801a057a"
    sha256 cellar: :any, arm64_tahoe:       "68bb9f8b47204fe1f7e13491cd67366a224ffb333f5025d6340ad87cc49b16f2"
    sha256 cellar: :any, arm64_sequoia:     "b2ab244fd297cb7ee7d5f41e95daf61c5b2414a662ab84d79e4898576a91dee5"
    sha256 cellar: :any, arm64_linux:       "a36c6e0a7f622360d09c7f722c7b97c428580c98995f2238eff97c12e0030e49"
    sha256 cellar: :any, x86_64_linux:      "80c44d49552a07d7453d6ba393777109047bce5b20c58e24ab97a644e586d1d3"
  end

  depends_on "pkgconf" => :build
  depends_on "xorgproto" => :build
  depends_on "xorg-server" => :test

  depends_on "libx11"

  def install
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    IO.pipe do |read_io, write_io|
      xvfb = formula_opt_bin("xorg-server")/"Xvfb"
      pid = spawn(xvfb, "-displayfd", write_io.fileno.to_s, "-listen", "tcp", write_io => write_io)
      write_io.close
      ENV["DISPLAY"] = ":#{read_io.read.strip}"
      assert_match "pointer buttons defined", shell_output("#{bin}/xmodmap -pp")
    ensure
      if pid
        Process.kill "TERM", pid
        Process.wait pid
      end
    end
  end
end
