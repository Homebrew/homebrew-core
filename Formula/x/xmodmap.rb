class Xmodmap < Formula
  desc "Modify keymaps and pointer button mappings in X"
  homepage "https://gitlab.freedesktop.org/xorg/app/xmodmap"
  url "https://www.x.org/releases/individual/app/xmodmap-1.0.11.tar.xz"
  sha256 "9a2f8168f7b0bc382828847403902cb6bf175e17658b36189eac87edda877e81"
  license "MIT-open-group"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "3729b90bb68b33194e9a4ce31e854ecb2070ba5e5af11953f7c289cca5f17868"
    sha256 cellar: :any,                 arm64_sequoia:  "1a71168c6e5ae767004d75967ece8e8f41971b5e89072e05d1f68072c8857486"
    sha256 cellar: :any,                 arm64_sonoma:   "735be4fae3324a706814ab035dd4c7dbb9bf1a5095e15b00fed401376bab18cc"
    sha256 cellar: :any,                 arm64_ventura:  "7b0cf54bc0c8a2698037c366636a34d77fa31d3ae73e6024a51a5d6196e6a6e6"
    sha256 cellar: :any,                 arm64_monterey: "60bf2e38a007c44f962abaea1a1021c5c2fda7af694cebf2d5b0cafeec95f117"
    sha256 cellar: :any,                 arm64_big_sur:  "60a4ba16980f59c46bd94b18ede68b80fe9ed792375aaef1e7a4f317fb30859a"
    sha256 cellar: :any,                 sonoma:         "0a6d9f46dfc724b3e19dd881676f5ef2911aa52c13c2ebf901e3edca3c862667"
    sha256 cellar: :any,                 ventura:        "c6c74699c3c0f00941f5d7efc899ceaa34c7649b1722800665d1b3bcaa0b0afc"
    sha256 cellar: :any,                 monterey:       "93d72a0e4ba5b24d81acee6f9432fb008f0ca0cb265708ada4a0f338978c29fe"
    sha256 cellar: :any,                 big_sur:        "3971a72f9a768b7d3648af48750db8fc25f89733b0824d2695cd2022b00ca0db"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "b49840b06e245234d26698932373881179ff1763e348dfb3dfb22fd993f45371"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8866422cea1dfecb73e767819e793be7d9f6acf91c1f21611809126c54985c4"
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
    fork do
      exec Formula["xorg-server"].bin/"Xvfb", ":1"
    end
    ENV["DISPLAY"] = ":1"
    sleep 10
    sleep 10 if OS.mac? && Hardware::CPU.intel?
    assert_match "pointer buttons defined", shell_output("#{bin}/xmodmap -pp")
  end
end
