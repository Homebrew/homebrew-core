class Scale2x < Formula
  desc "Real-time graphics effect"
  homepage "https://www.scale2x.it/"
  url "https://github.com/amadvance/scale2x/releases/download/v4.0/scale2x-4.0.tar.gz"
  sha256 "996f2673206c73fb57f0f5d0e094d3774f595f7e7e80fcca8cc045e8b4ba6d32"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "46d736eb0b365a16a20ae85c4d4f1f957491666df314029dfa1183d986cf9f2f"
    sha256 cellar: :any,                 arm64_sequoia: "ba1b6ceb8693ea2479b14398ac09a5ae05927a71a648e96c116eaa0e81b4a229"
    sha256 cellar: :any,                 arm64_sonoma:  "dc0bee122c9f32ef4aed40b010794826ffb5a652883c7fa56ab83a3d517e8fb1"
    sha256 cellar: :any,                 sonoma:        "cd2e6f84caf00aa13086023312951a244ab9eff1e5d4d6f85fd92cf7e9aca65a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1b80d41351265e0cfd18667a46c1da1fedecc86016d34bb6d9f6e883eef12d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "303eee8c3a01ff0d761da659aaa2d94f871f608221362dfdc668e124afebb69b"
  end

  depends_on "libpng"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"scalex", "-k", "2", test_fixtures("test.png"), "out.png"
    assert_path_exists testpath/"out.png"
  end
end
