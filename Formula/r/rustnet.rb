class Rustnet < Formula
  desc "Cross-platform network monitoring terminal UI with deep packet inspection"
  homepage "https://github.com/domcyrus/rustnet"
  url "https://github.com/domcyrus/rustnet/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "9d3f6509da06f832c04c5accc7b777c18f3de8b32c885137c9a1346990694dda"
  license "Apache-2.0"
  head "https://github.com/domcyrus/rustnet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b35e186260713cd0a4d0a597923b104ca05d01069d0c1b69919fd4356ca7a3bc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4ac0572fc99041b35b70422aae060a83998cd8eacbdacb2a2cff2e055135fee8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0d288af449c199ffb5aab9e1ddcef1bbeb7c02764748cf1934bcfe39c478aa50"
    sha256 cellar: :any,                 arm64_linux:       "2246158eef64862eb211534ac540aeedf87cc317ff83f1373ee3558f804993f6"
    sha256 cellar: :any,                 x86_64_linux:      "e748bd73ccbc8e0d499f6a29793191392613bc684c2d849ccd6720fb6a730cc4"
  end

  depends_on "rust" => :build

  uses_from_macos "libpcap"

  on_linux do
    depends_on "llvm" => :build
    depends_on "pkgconf" => :build
    depends_on "elfutils"
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
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

    output = shell_output("#{bin}/rustnet --headless --log-level not-a-level 2>&1", 1)
    assert_match "Invalid log level", output
  end
end
