class Rustnet < Formula
  desc "Cross-platform network monitoring terminal UI with deep packet inspection"
  homepage "https://github.com/domcyrus/rustnet"
  url "https://github.com/domcyrus/rustnet/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "846f89a9c6cb5a2de6b9d42cf5a8a435e343906cbe9083776ddcc7fdbbb8857b"
  license "Apache-2.0"
  head "https://github.com/domcyrus/rustnet.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "28ca4ad2fba70115eb1bec9838f723e6c8d8aec356809a8fbe20c61f1fefa28d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e78b87995797d057c7fa48bd47b5d59d27a70441088aae8a8ba2ca81db1236e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78918b44799c98314278a85e3fae4fb139925efea11e5a62b6be975c2ae7b952"
    sha256 cellar: :any_skip_relocation, sonoma:        "a74daab23db480e2de9aedf36cede91355e32aa1acd50ba29a72c7dd2dff8280"
    sha256 cellar: :any,                 arm64_linux:   "c88dff5f29905a343ed524e08ce9e8f2b231559fd509792efbff59de3a92121c"
    sha256 cellar: :any,                 x86_64_linux:  "8cb1d7cb93b04c8384dbfaaf487358ec4b79421ee114c268bae183fb9f67c137"
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
