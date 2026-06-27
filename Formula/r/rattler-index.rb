class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.30.7.tar.gz"
  sha256 "ddaea3bf682c4fc9d610a5f6529c5743b74191091bd5da7da11af30232ea5971"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "42dfb211c6a19befba0aee5a7b0f7a3e6d4ce0b807576ced7fb9c24f509a6d58"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e257adb7ab3f59489610b1c480af6bcce5976797310af1658bb79af1b6828168"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5abb80a7b94d40cffe4a2002d45b1aa3fb76fa33362e1c1be07407dd829b7ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b0a8241a194d5f952e00d8c159ee6f00f3dee02f1a5f237137f7e8ddca4d334"
    sha256 cellar: :any,                 arm64_linux:   "5f8e065d899bb6ee4a50879b436fbd107dc9452affc4d4ee51c00502c8fbe3bf"
    sha256 cellar: :any,                 x86_64_linux:  "ad030a29bafff9d1edd9ea44442bfc31f1f32a04f0934bc50cbc3914c6d716e2"
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
