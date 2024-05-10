class Rage < Formula
  desc "Simple, modern, secure file encryption"
  homepage "https://str4d.xyz/rage"
  url "https://github.com/str4d/rage/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "34c39c28f8032c144a43aea96e58159fe69526f5ff91cb813083530adcaa6ea4"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/str4d/rage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fe679e4dd957148d5c62d465aae7f451c0160ef7ec02629abecc31ef48a76355"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5528b1d13be084d4889823a2343aa3ce5c194add31ddb1f845f9b48673ecdd8a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a6c1eb10260bdc634ff9e9c6a0ccd160b8d6761d0f60cf4a134b166b04de8499"
    sha256 cellar: :any_skip_relocation, sonoma:         "be1b5a328299875623fcb7b72469eb8522d3ff549e0f263442bf313f60b51bcb"
    sha256 cellar: :any_skip_relocation, ventura:        "b4d186b9ef6805e18cd695adfd9eb5608797a3332633f73cdcae1fe8401106d5"
    sha256 cellar: :any_skip_relocation, monterey:       "6b92ec9a3f5c4413663aa63c657d22c63b75c66a146f860c4e36f6c9d83955d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7c4f61c4674059a51330260e541601e4b639a65805c22c9e42c5e7764f4353d"
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
    system "#{bin}/rage-keygen", "-o", "#{testpath}/output.txt"
    assert_predicate testpath/"output.txt", :exist?

    # Test encryption
    (testpath/"test.txt").write("Hello World!\n")
    system "#{bin}/rage", "-r", "age1y8m84r6pwd4da5d45zzk03rlgv2xr7fn9px80suw3psrahul44ashl0usm",
      "-o", "#{testpath}/test.txt.age", "#{testpath}/test.txt"
    assert_predicate testpath/"test.txt.age", :exist?
    assert File.read(testpath/"test.txt.age").start_with?("age-encryption.org")

    # Test decryption
    (testpath/"test.key").write("AGE-SECRET-KEY-1TRYTV7PQS5XPUYSTAQZCD7DQCWC7Q77YJD7UVFJRMW4J82Q6930QS70MRX\n")
    assert_equal "Hello World!", shell_output("#{bin}/rage -d -i #{testpath}/test.key #{testpath}/test.txt.age").strip
  end
end
