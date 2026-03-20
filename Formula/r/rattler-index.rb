class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.27.19.tar.gz"
  sha256 "646fe4fe83be9c2d8debe4e2364204fab378d9a1b24ff465114ea93c2131dde3"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "644223990adb75476e7864cbd3df5368d9fbc88d430c293c3dc84e0c1ab4c72e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24315c3dbbf132955422b31ea0300b1f105b111abae62644f140da6c8164136f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97e3302df219f78fbb4afed96590b43aed2af958b0007c62d6a2a328c433dbab"
    sha256 cellar: :any_skip_relocation, sonoma:        "f170d4acbe77e706be494dbe4d580a8acd56040efb74fdba947a49efdb71869c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e0837a5a1a0d93d0a6d9b40891a14fb869e0006aca983e3384e56f44071a8d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "216e3760e2e58e9ff939feb784301baaf120ee2cd4f89374cbdcebf52ee74ff2"
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
