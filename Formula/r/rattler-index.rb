class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.27.8.tar.gz"
  sha256 "a3cac1098b049a4543a66c0a0e7648fcdb7875c8880a19ce563b8ad078a9f13f"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4259b95df1241f1a9b86915a30a5f4529f93a19acefbeb8c1933307b241adda5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a089338af70e4c6d6b0dff431bcc8773d66fb32e9bed67d748d9486c2452e8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da6bb15f484cae740207fccf7b8a1afdfa374f4c1341490aebfed5b4121ec59f"
    sha256 cellar: :any_skip_relocation, sonoma:        "1aaf48c8e2dd5382fe0ae881366470f53cdc4abb8329c6bb4eb00d5e529bf169"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c6540ef2a2b59c40498050a288db7bac5ab5666a58ffd4a3eb0ca427b6d64e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02bc7b5c10a3ace1ad31fe2129b95aed83823233715c054d73b7747a275ee6f9"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", "--features", "native-tls,rattler_config", "--no-default-features",
        *std_cargo_args(path: "crates/rattler_index")
  end

  test do
    assert_equal "rattler-index #{version}", shell_output("#{bin}/rattler-index --version").strip

    system bin/"rattler-index", "fs", "."
    assert_path_exists testpath/"noarch/repodata.json"
  end
end
