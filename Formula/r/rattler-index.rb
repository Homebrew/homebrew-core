class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.28.2.tar.gz"
  sha256 "9885bf03afd3fd43f70051d7da90e90dda21f1cf7998766a239c4dbad0b9a40c"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8896d23a6296aef2a1d55f2986a48bd135b76e53d2113a1dd3093e99fd9d1d3b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6efad577e7c5d0f74cf2a4f297664950d0851d5b9df8fca5a2d8770981393587"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8dab0292f4504b8c11a6c2293ff698c527e9d5f3d891cc8835ea755000e2977"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e0ba11590758ad041623ec3d95a9d6f7c18c62d603a3f3223a3441e458ece6d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d778ed32b3873cbd059e261473eeb0e497c6ab013e5b7c2d05b977945538c3cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0878e0acfba1bc1b1f3059b0693ce1e93ac14d6ca3069fce771de9f05bf57f8"
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
