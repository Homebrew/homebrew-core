class Sassc < Formula
  desc "Wrapper around libsass that helps to create command-line apps"
  homepage "https://github.com/sass/sassc"
  url "https://github.com/sass/sassc.git",
      tag:      "3.6.2",
      revision: "66f0ef37e7f0ad3a65d2f481eff09d09408f42d0"
  license "MIT"
  head "https://github.com/sass/sassc.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f1814e87c905c18e7a39512e02a10ed93b68c81493f5d23e61884d0b3262d529"
    sha256 cellar: :any,                 arm64_big_sur:  "ae86a3868be7edf32aadf47abd949d3806789f5edf319c4d86120a05fee9053d"
    sha256 cellar: :any,                 monterey:       "1dc3c04d8527c5b13983c6e5fa405f6e0af6315bd72e06047e53c6a2c7f1c32c"
    sha256 cellar: :any,                 big_sur:        "fe3a719ec1b2b01385924b8cb3bbb758d006ff3dbd75b1c3691ce09a43d1ebcd"
    sha256 cellar: :any,                 catalina:       "0826a1c50657da448806febb03694bce523e60ac56e7dd0de7362fe4b41f2277"
    sha256 cellar: :any,                 mojave:         "6aa4de7c6d9b1b64beda27f0c06a6d8c9224616b74ae48ea8e706f166b374ce9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4575b459543c822d40a074f73591b1865790aa8977e7dc12148c10c858d55203"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libsass"

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--prefix=#{prefix}", "--disable-silent-rules",
                          "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    (testpath/"input.scss").write <<~EOS
      div {
        img {
          border: 0px;
        }
      }
    EOS

    assert_equal "div img{border:0px}",
    shell_output("#{bin}/sassc --style compressed input.scss").strip
  end
end
