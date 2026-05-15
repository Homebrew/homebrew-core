class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.29.0.tar.gz"
  sha256 "2d0f7f5deea5023debb2db042659c3dd8382e1c982b770433d168081b447e8f7"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0569ba435c6d7ca57d136751c9d9349b98fe35fcb96a750fe3bd198d31d1decd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fbf3e85bc6ca1284055a2b2953c659e30ae088753368f289279179056cc1a544"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "960bd04c1efa0670c2d182f1ab46a27da872ca418b599f83274f2f8c1cb432b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9bce88cf2cf6ad63d3cfb62f055a842cbc7005fb89f3998c16f62d9d738672a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "138a716cdcab8953f8dec6b3752673010ffcdb8322636a2e46201fd32bdb9683"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e50dd00af8f08246e1052d6157f229489411605f25908c829bb107ed52ab29d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@4"].opt_prefix if OS.linux?
    features = %w[native-tls rattler_config s3]
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/rattler_index", features:)
  end

  test do
    assert_equal "rattler-index #{version}", shell_output("#{bin}/rattler-index --version").strip

    system bin/"rattler-index", "fs", "."
    assert_path_exists testpath/"noarch/repodata.json"
  end
end
