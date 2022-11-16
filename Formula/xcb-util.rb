class XcbUtil < Formula
  desc "Additional extensions to the XCB library"
  homepage "https://xcb.freedesktop.org"
  url "https://xcb.freedesktop.org/dist/xcb-util-0.4.0.tar.bz2"
  sha256 "46e49469cb3b594af1d33176cd7565def2be3fa8be4371d62271fabb5eae50e9"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1f5500915eb755309ec7f739f2a9f3e388565bd1bf3536ed6b4257a1c9c06563"
    sha256 cellar: :any,                 arm64_monterey: "1a0e16a327950b2254fb73fcf1e4853c5babab349910e21687587f25cae5772c"
    sha256 cellar: :any,                 arm64_big_sur:  "8d86304598d174005688503ce824bd1630482c357aa7de536eafd57d22041054"
    sha256 cellar: :any,                 ventura:        "34028eea53ade5804e9902ab4ce8da92ec667a696f5a4df90a5fbbdf28fb0dc9"
    sha256 cellar: :any,                 monterey:       "d57ff03eb28121c68dc58a0fffe572e881bcd2c9f5a19ec70af907746f25fe37"
    sha256 cellar: :any,                 big_sur:        "ca7b806f016b95c52654a351d966ee86e46dcc36339a44921fccc311c1d607a8"
    sha256 cellar: :any,                 catalina:       "c161b6f0372d40ace1238507365c18a52581b798262c856099cd86eabc38c625"
    sha256 cellar: :any,                 mojave:         "0979f730b01775f3dcb33c093132ec25a49912b99e679e774bae0e995fc3f73c"
    sha256 cellar: :any,                 high_sierra:    "16578b76b505e33f0ccb428a947e475520d78f4dd7a56504ff9e0af9870793cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ba45c0981b52a8e1e33b0d005948476dbde71d2484ef4e01c84e0522c5e7052"
  end

  depends_on "pkg-config" => [:build, :test]
  depends_on "libxcb"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "-I#{include}", shell_output("pkg-config --cflags xcb-util").chomp
  end
end
