class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.27.23.tar.gz"
  sha256 "4e3d8180eaeb2a4242757be6b2937655cb9027dfb347ef79562bd6e9496e6e1d"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f4dea89fd6e979ed5e339ef8151d5250cb1271cad296c6b4e569331cc5e30719"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bde10a33b3854dfcc10605ebb1f841b52eb4a1c3482a02571c7ae9f4a4f9cc72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b5d1c068c736748138eccd5b8ec7bd347ec3d7a0342545bfb9a68b639aaceb9"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a9c6f0c39b31bfbdc3fc926d558acadd85edfa6b0e6b0aa3559d20640430f83"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0188ae5992bda8d6d2187cb21f50efe3748c43a0b640faa5fb112d9f3bf4c4f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "863c0661cfc199ee8b94527a734e73feac37ffda5c803905f43db8ce2f462853"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    features = %w[native-tls rattler_config s3]
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/rattler_index", features:)
  end

  test do
    assert_equal "rattler-index #{version}", shell_output("#{bin}/rattler-index --version").strip

    system bin/"rattler-index", "fs", "."
    assert_path_exists testpath/"noarch/repodata.json"
  end
end
