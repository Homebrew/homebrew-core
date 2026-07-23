class Rustnet < Formula
  desc "Cross-platform network monitoring terminal UI with deep packet inspection"
  homepage "https://github.com/domcyrus/rustnet"
  url "https://github.com/domcyrus/rustnet/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "f6425992dc5a8a700323c1231d1833a135cd93424d86cfaa788eed6cb700fe33"
  license "Apache-2.0"
  head "https://github.com/domcyrus/rustnet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3578a83e470b58331c00842cecb14a9a8c2ecb0072b9006f12e4472ea311a249"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e13b19e92dec26182352255fa2cf59e48a07df105e755387e8eb91f510911c76"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47ab9d884ce965aaf554d591f1ff067edf7bd667c4cac3fc6047ae832502d7f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3035e64abb9af9547919c2032e8180d104295e3db137982f8679118c206ec8b"
    sha256 cellar: :any,                 arm64_linux:   "ec6bf2579e8df002e9afd245273d25d6398ccd475d13636be9c1f7641a2237ce"
    sha256 cellar: :any,                 x86_64_linux:  "5f4410028edd95ca29287602ac599880bc97be152ef0d26c002179a0d3c07cf4"
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
