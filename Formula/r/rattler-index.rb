class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.30.10.tar.gz"
  sha256 "8f3c9142d0526578510bc29df05fcf4028dd4a9859b85c39b6381887a77356e0"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ae1222fee36d7316e050aad8de1c7af4fbc7646362f069149365fc1d2c68ec2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d0b8fe46f59b1f384c58c0130d598ebda08d1debad6e52ecfa3b3893b519765"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d49a301b53d38e2114d6216bc839308b6aea1a74533e51df73c55cab181d01f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "64929a2d9517122abbb1baebbe43317f346bc997dba7e225efcaf381088441f7"
    sha256 cellar: :any,                 arm64_linux:   "f23f481b47d95cb09d5534990f513aa5305e09caf95593aa4b85fcf36b8c0b95"
    sha256 cellar: :any,                 x86_64_linux:  "b8cbc84761f4ca5997ae76c1f6fc3411fa0aa667ca8ab92185436dac3a42b799"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4") if OS.linux?
    features = %w[native-tls s3]
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/rattler_index", features:)
  end

  test do
    assert_equal "rattler-index #{version}", shell_output("#{bin}/rattler-index --version").strip

    system bin/"rattler-index", "fs", "."
    assert_path_exists testpath/"noarch/repodata.json"
  end
end
