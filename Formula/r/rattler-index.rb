class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.22.4.tar.gz"
  sha256 "143f35d9bdf6a1922dc5bca20ecfa5824101117b950b8ec0f542184fe8a05419"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "845dfd5ba0319fda91fa057a04b67e9e650b8131b8e7205ae57be188f97f055c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0008300c28ece10dbb76e8b5a2ec4dde8b11d4ae063f0bb53ba967a8f9a5d8c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6c9e538d8d59ad66df8245115cc158f638b71285042fb9a5bb0246e193ce45c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "3721a23b2d2b6be8dccee82e28592973d665e60e60ed4bb97fe90cce60b0c963"
    sha256 cellar: :any_skip_relocation, ventura:       "ccda390b82763abfa19ec7618968eb65bf69c76ae920c113ec6923510787d017"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5c552a08075810e2d76323d75ccff37a920b3ba4b81e45369d15c62b43145f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed3b7ad00493558439f3631f05afc0923614941040210637546c389c65415d51"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", "--features", "native-tls", "--no-default-features",
        *std_cargo_args(path: "crates/rattler_index")
  end

  test do
    assert_equal "rattler-index #{version}", shell_output("#{bin}/rattler-index --version").strip

    system bin/"rattler-index", "fs", "."
    assert_path_exists testpath/"noarch/repodata.json"
  end
end
