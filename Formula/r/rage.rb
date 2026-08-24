class Rage < Formula
  desc "Simple, modern, secure file encryption"
  homepage "https://str4d.xyz/rage"
  url "https://github.com/str4d/rage/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "3684e7e269a677180db116cb8115b008ea462dbb6f223f6983dd6750a863afaa"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/str4d/rage.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9250e8f6fe6570b0114a6fd5c126321bcdd61a3992d37b091ca54057cc755e6c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3247d880b679a63e3e43a0e88e6eb7d572fbfe7b1f3d2c5f763e516b0703444"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88af4e5a9cb1f6580db2db623b1abf26045e496f8c210eaa81c5232b0452460f"
    sha256 cellar: :any_skip_relocation, sonoma:        "84d38fea1dd68d5f96f16706ba99ffe1b91ac0c2a064f7f8b9f747eed0af9d95"
    sha256 cellar: :any,                 arm64_linux:   "536881fd992d02a6a3727f45ef1e19a5278a55f5ec3197e7f82a8e3000fac133"
    sha256 cellar: :any,                 x86_64_linux:  "210452cad18966c26e2a3d986101f0cabd95364c4bae08c933a46d62552d60f1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "./rage")

    src_dir = "target/release/completions"
    bash_completion.install "#{src_dir}/rage.bash" => "rage"
    fish_completion.install "#{src_dir}/rage.fish"
    zsh_completion.install "#{src_dir}/_rage"
    bash_completion.install "#{src_dir}/rage-keygen.bash" => "rage-keygen"
    fish_completion.install "#{src_dir}/rage-keygen.fish"
    zsh_completion.install "#{src_dir}/_rage-keygen"

    man.install Dir["target/release/manpages/*"]
  end

  test do
    # Test key generation
    system bin/"rage-keygen", "-o", testpath/"output.txt"
    assert_path_exists testpath/"output.txt"

    # Test encryption
    (testpath/"test.txt").write("Hello World!\n")
    system bin/"rage", "-r", "age1y8m84r6pwd4da5d45zzk03rlgv2xr7fn9px80suw3psrahul44ashl0usm",
      "-o", testpath/"test.txt.age", testpath/"test.txt"
    assert_path_exists testpath/"test.txt.age"
    assert_equal "age-encryption.org/v1", File.open(testpath/"test.txt.age", &:gets).chomp

    # Test decryption
    (testpath/"test.key").write("AGE-SECRET-KEY-1TRYTV7PQS5XPUYSTAQZCD7DQCWC7Q77YJD7UVFJRMW4J82Q6930QS70MRX\n")
    assert_equal "Hello World!", shell_output("#{bin}/rage -d -i #{testpath}/test.key #{testpath}/test.txt.age").strip
  end
end
