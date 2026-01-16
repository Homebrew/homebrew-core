class Sassc < Formula
  desc "Wrapper around libsass that helps to create command-line apps"
  homepage "https://github.com/sass/sassc"
  url "https://github.com/sass/sassc.git",
      tag:      "3.6.2",
      revision: "66f0ef37e7f0ad3a65d2f481eff09d09408f42d0"
  license "MIT"
  head "https://github.com/sass/sassc.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "331445fe56f4536be8c84306ed15216102d9653ad84c90b3ea2dd93d54cfb4e8"
    sha256 cellar: :any,                 arm64_sequoia:  "76372bcf1accae3510d1f2cd03f6a10f9a9016221e541e3b356021eaa5af18be"
    sha256 cellar: :any,                 arm64_sonoma:   "5f840fc12c44dabbade2ec934710c03adbcfa33f1b62903542dd03f169171f52"
    sha256 cellar: :any,                 arm64_ventura:  "9302f8cb296175ea2f685b1b688753f4a0e66243c53f2249586ede9576bf86b6"
    sha256 cellar: :any,                 arm64_monterey: "f1814e87c905c18e7a39512e02a10ed93b68c81493f5d23e61884d0b3262d529"
    sha256 cellar: :any,                 arm64_big_sur:  "ae86a3868be7edf32aadf47abd949d3806789f5edf319c4d86120a05fee9053d"
    sha256 cellar: :any,                 sonoma:         "4e667e662081a4741edb5ce0ae92cb909143ca3d3ef817925babe73af3821039"
    sha256 cellar: :any,                 ventura:        "1bd79d455cd4dac5f3e335088f760b4971297834d7a5c733c77de5cf747dea5c"
    sha256 cellar: :any,                 monterey:       "1dc3c04d8527c5b13983c6e5fa405f6e0af6315bd72e06047e53c6a2c7f1c32c"
    sha256 cellar: :any,                 big_sur:        "fe3a719ec1b2b01385924b8cb3bbb758d006ff3dbd75b1c3691ce09a43d1ebcd"
    sha256 cellar: :any,                 catalina:       "0826a1c50657da448806febb03694bce523e60ac56e7dd0de7362fe4b41f2277"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "074f6ea2972c1b7d50f9e3bbbfde7d8ca06d1c2e96474115bc33aca3b64a4cda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4575b459543c822d40a074f73591b1865790aa8977e7dc12148c10c858d55203"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "libsass"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", *std_configure_args
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
