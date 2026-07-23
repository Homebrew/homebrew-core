class Xmodmap < Formula
  desc "Modify keymaps and pointer button mappings in X"
  homepage "https://gitlab.freedesktop.org/xorg/app/xmodmap"
  url "https://www.x.org/releases/individual/app/xmodmap-1.0.12.tar.xz"
  sha256 "fc54b9b5bbf2ae58ba8f9d42bd051c41c7438377400c42c17d7496d19e1bb3ce"
  license "MIT-open-group"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c3b0bb370a24a58f47900b7c8de2f456a06b132b2393771de3eeddb58c6feb08"
    sha256 cellar: :any, arm64_sequoia: "0dc638f9b5e5aaf88a883bc272da101259528f3ee067fa70b17e1bcc48fed1ce"
    sha256 cellar: :any, arm64_sonoma:  "7d11539d6e3fca0fb205dce1b20cd84bcab923eca276a225672297e784711f31"
    sha256 cellar: :any, sonoma:        "9494ffad49af73ce07954c6810636496ef1844da9e7ff965c0ca6975f3f1862f"
    sha256 cellar: :any, arm64_linux:   "c5741ad3aca85ff6ce27564f5a36fc8547e2a3ca859da54b5da9ef541f61b44c"
    sha256 cellar: :any, x86_64_linux:  "866b3f94f7ac54940a1e489cd303362aedbeabf115362024fea415d6929f9311"
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
    spawn Formula["xorg-server"].bin/"Xvfb", ":1"
    ENV["DISPLAY"] = ":1"
    sleep 10
    sleep 10 if OS.mac? && Hardware::CPU.intel?
    assert_match "pointer buttons defined", shell_output("#{bin}/xmodmap -pp")
  end
end
