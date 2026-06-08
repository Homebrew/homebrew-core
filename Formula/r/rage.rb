class Rage < Formula
  desc "Simple, modern, secure file encryption"
  homepage "https://str4d.xyz/rage"
  url "https://github.com/str4d/rage/archive/refs/tags/v0.11.2.tar.gz"
  sha256 "a8e5c57f131683f86957af7fddeccf61a3882383dd24e752bab3855f570c086c"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/str4d/rage.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "68d6140c371a9fead1ea6af7c6fd6a9315340c3c551d2173d7b96d6f1fc1030c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d0f85836dee6caba6c9b6a0010b2f050b453b573d12f7857ccf662b12ec0bf8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4596d2bd7ad27850df253075e440406a798301e0ee3f385dc694e39eaa83e5f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c674f10a48f3453bff0a95a15f74dee1bb69a43f659b339d12948934dc528fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc6577de7682491deffd989040906da668282ef05a4cf9c01e3a6243390255c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38cbf2240f62ed2335aac458a1a8f41bcfa7edb408678688ee2dcf72711791de"
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
