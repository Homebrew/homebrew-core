class Rustnet < Formula
  desc "Cross-platform network monitoring terminal UI with deep packet inspection"
  homepage "https://github.com/domcyrus/rustnet"
  url "https://github.com/domcyrus/rustnet/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "245fc7074d5f142fbf1c798233be86b715b4f2ce3b3cfec10fabdcbbc9345ddb"
  license "Apache-2.0"
  head "https://github.com/domcyrus/rustnet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "124e36870eb6df29a1f8c3f8627068768928564a9f641ca1e46c69193aa1be91"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9063bc074d000465e125880133bd14604ea1451f95d951bab92f11cf79ef40cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8c35db42d28e7367dd5ee37faf79c8b780ab9c353e5ab4ef22357b02d754cd4"
    sha256 cellar: :any_skip_relocation, sonoma:        "49576d784e88386da8d5aa00584d368c41950bd9150aa0a7e4a5e65380751383"
    sha256 cellar: :any,                 arm64_linux:   "7d12229ed65abffae4bd0a9291a6cb1134c8bdcade0c609e7aa86cee36205316"
    sha256 cellar: :any,                 x86_64_linux:  "27a018656a865858d48e177fb2893f6e96e5db746ff35ed0163e71a14b1feca0"
  end

  depends_on "rust" => :build

  uses_from_macos "libpcap"

  on_linux do
    depends_on "llvm" => :build
    depends_on "pkgconf" => :build
    depends_on "elfutils"
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["RUSTNET_ASSET_DIR"] = buildpath/"assets-generated"
    (buildpath/"assets-generated").mkpath

    if OS.linux?
      # Homebrew's compiler shim rewrites `clang` invocations to `gcc`, which
      # breaks libbpf-cargo's BPF compile step (it runs `clang -target bpf`,
      # an option gcc rejects). Surface the real clang from llvm in a shim
      # dir that we place first on PATH; regular C compiles still go through
      # Homebrew's gcc as intended.
      (buildpath/"bpf-clang").mkpath
      (buildpath/"bpf-clang"/"clang").make_symlink formula_opt_bin("llvm")/"clang"
      ENV.prepend_path "PATH", buildpath/"bpf-clang"
    end

    system "cargo", "install", *std_cargo_args

    asset_dir = buildpath/"assets-generated"
    bash_completion.install asset_dir/"rustnet.bash" => "rustnet"
    zsh_completion.install asset_dir/"_rustnet"
    fish_completion.install asset_dir/"rustnet.fish"
    man1.install asset_dir/"rustnet.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rustnet --version")
    assert_match "network monitoring", shell_output("#{bin}/rustnet --help").downcase

    output = shell_output("#{bin}/rustnet --log-level not-a-level 2>&1", 1)
    assert_match "Invalid log level", output
  end
end
