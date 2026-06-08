class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.30.3.tar.gz"
  sha256 "88cc1eb7ffa9fc9977ed1cd2630ab5c1de633a52e5b424f54d35636309de026c"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e0d353c3b02e086b6738c2d0bc3de34bbaed2a5e1aa5ded9f7c2aba3ae6b2906"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26f08608149d20327ed2782417491976feb3ab14e17f006f523592256c6023cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8525fd22120cfc4b045e0eac0946dbbf2a59d3e23f0cb24753d2856f83d3d25d"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a3b21aad22d25183507eb6b839ace70ffd022233ff9566d6342055789c74a77"
    sha256 cellar: :any,                 arm64_linux:   "b8add3f853cf28d89060d259448716a79b28b1a09a56be65e13a8b9a16b68882"
    sha256 cellar: :any,                 x86_64_linux:  "17e6c60f13dcbd12ead41684faa530c24616ed95bf1833c203c9f32570797216"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@4"].opt_prefix if OS.linux?
    features = %w[native-tls s3]
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/rattler_index", features:)
  end

  test do
    assert_equal "rattler-index #{version}", shell_output("#{bin}/rattler-index --version").strip

    system bin/"rattler-index", "fs", "."
    assert_path_exists testpath/"noarch/repodata.json"
  end
end
