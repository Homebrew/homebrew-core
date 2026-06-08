class Rustnet < Formula
  desc "Cross-platform network monitoring terminal UI with deep packet inspection"
  homepage "https://github.com/domcyrus/rustnet"
  url "https://github.com/domcyrus/rustnet/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "258ea142f3ca04e45c33761eb28868a8d8afc62a3f9556a1d5b312e805905ce5"
  license "Apache-2.0"
  head "https://github.com/domcyrus/rustnet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed765cd6481ccc2cd24c4e902272ae075a8d8092dd5fe0a6e58632c764f99504"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8aa8187cff84d15ac84c43c59abca16b85523eff33f3f92ed3164f64fc7f271d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed5fd8a6a29c0f519808468560084f3b9c57eb86a2c79e1886840c50f906f4db"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8299a8b442a7049a44a6772d1a376aaf4b67f0a43e72a78b860f9cfd419f44a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01a2c4e7669e19cdb979d1e8872c31758b429d74ffc7556e2cdf42e319b6aa8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96fae2119f9b26d5700219f58fe4b1829552aa4390be08169725d5ee19ea1bd2"
  end

  depends_on "rust" => :build

  uses_from_macos "libpcap"
  uses_from_macos "zlib"

  on_linux do
    depends_on "llvm" => :build
    depends_on "pkgconf" => :build
    depends_on "elfutils"
  end

  # Skip cross-rs-specific lib search paths on native Linux builds.
  # Already merged upstream; will no longer apply on the next release.
  # https://github.com/domcyrus/rustnet/pull/259
  patch do
    url "https://github.com/domcyrus/rustnet/commit/9a5208d95904253dbae19fd548f44a91cafbd34f.patch?full_index=1"
    sha256 "bc677735d7ae9924214df0d4cfc261346eab429bc11f182c09c93fbde474673b"
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
      (buildpath/"bpf-clang"/"clang").make_symlink Formula["llvm"].opt_bin/"clang"
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
    assert_match "rustnet #{version}", shell_output("#{bin}/rustnet --version")
    assert_match "network monitoring", shell_output("#{bin}/rustnet --help").downcase

    output = shell_output("#{bin}/rustnet --log-level not-a-level 2>&1", 1)
    assert_match "Invalid log level", output
  end
end
