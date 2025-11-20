class Xorgproto < Formula
  desc "X.Org: Protocol Headers"
  homepage "https://www.x.org/"
  url "https://xorg.freedesktop.org/archive/individual/proto/xorgproto-2024.1.tar.gz"
  sha256 "4f6b9b4faf91e5df8265b71843a91fc73dc895be6210c84117a996545df296ce"
  license "MIT"

  livecheck do
    url :stable
    regex(/href=.*?xorgproto[._-]v?(\d+\.\d+(?:\.([0-8]\d*?)?\d(?:\.\d+)*)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "b657ca11743e2fa56088464f5eaceeae524af6eb3b5c0f6e916678209f25a6af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "91066363512e4a3b01644398886815eb370bc8f62611f7ee20c23c7350b4422e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3307601f0a03f6c51b640fb11064ef2c2264cc9c20de0604a255370edee3f7f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3307601f0a03f6c51b640fb11064ef2c2264cc9c20de0604a255370edee3f7f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3307601f0a03f6c51b640fb11064ef2c2264cc9c20de0604a255370edee3f7f4"
    sha256 cellar: :any_skip_relocation, sonoma:         "3307601f0a03f6c51b640fb11064ef2c2264cc9c20de0604a255370edee3f7f4"
    sha256 cellar: :any_skip_relocation, ventura:        "3307601f0a03f6c51b640fb11064ef2c2264cc9c20de0604a255370edee3f7f4"
    sha256 cellar: :any_skip_relocation, monterey:       "3307601f0a03f6c51b640fb11064ef2c2264cc9c20de0604a255370edee3f7f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "6e87b7448405526b6fdb83a082b5cf4696f4042f7cf5c2c2195f94f8faa04e67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc1ef8db0fe244a7a47541fe8494131a281814a4110d3af41d76226274601df7"
  end

  depends_on "pkgconf" => [:build, :test]
  depends_on "util-macros" => :build

  def install
    args = %W[
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-silent-rules
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    assert_equal "-I#{include}", shell_output("pkg-config --cflags xproto").chomp
    assert_equal "-I#{include}/X11/dri", shell_output("pkg-config --cflags xf86driproto").chomp
  end
end
