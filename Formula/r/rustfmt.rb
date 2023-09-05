class Rustfmt < Formula
  desc "Format Rust code"
  homepage "https://rust-lang.github.io/rustfmt/"
  url "https://github.com/rust-lang/rustfmt/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "32ba647a9715efe2699acd3d011e9f113891be02ac011d314b955a9beea723a2"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/rust-lang/rustfmt.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "903b03af5ff31da6946b920a87c360779bd7350371f9cf0fc8f1ac01797a22ba"
    sha256 cellar: :any,                 arm64_monterey: "2d4384367fb918037862e0f4167f31e79a45ab0d4464689782e5e1ef430ea415"
    sha256 cellar: :any,                 arm64_big_sur:  "2dfac00e73d1798016738b0f3ad4b1479e5e3e0801ef0986718e010d9fb231f3"
    sha256 cellar: :any,                 ventura:        "2d54800a6dff9d2f158b9e00ec8c59c99e88a17427b0d56887bdfc5067854b56"
    sha256 cellar: :any,                 monterey:       "72863634fc6b628f2a563194678796b16e2b8e1a46e87297a6b5684026840c40"
    sha256 cellar: :any,                 big_sur:        "66caede3491722db90a8a53dd758d95a9a52b38df13efa0bcd4ec5a713a784ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7177c8e937dd964b87c145479e2bf9c2ef7de15545489faaf2c988357ef4e190"
  end

  depends_on "rustup-init" => :build
  depends_on "rust" => :test
  uses_from_macos "zlib"

  def install
    system "rustup-init", "--profile", "minimal", "-qy", "--no-modify-path", "--default-toolchain", "none"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"

    ENV["CFG_RELEASE_CHANNEL"] = "stable"
    system "cargo", "install", *std_cargo_args

    # Bundle the shared libraries used by the executables.
    # https://github.com/NixOS/nixpkgs/blob/6cee3b5893090b0f5f0a06b4cf42ca4e60e5d222/pkgs/development/compilers/rust/rustfmt.nix#L18-L27
    bundled_dylibs = %w[librustc_driver libstd]
    bundled_dylibs << "libLLVM" if OS.linux?
    bundled_dylibs.each do |libname|
      dylib = buildpath.glob(".brew_home/.rustup/toolchains/*/lib/#{shared_library("#{libname}-*")}")
      libexec.install dylib
    end

    # Fix up rpaths.
    bins_to_patch = [
      bin/"rustfmt",
      bin/"git-rustfmt",
    ]
    bins_to_patch << libexec.glob(shared_library("librustc_driver-*")).first if OS.linux?
    bins_to_patch.each do |bin|
      extra_rpath = rpath(source: bin.dirname, target: libexec)
      if OS.mac?
        MachO::Tools.add_rpath(bin, extra_rpath)
        MachO.codesign!(bin) if Hardware::CPU.arm?
      elsif OS.linux?
        patcher = bin.patchelf_patcher
        patcher.rpath = [*bin.rpaths, extra_rpath].join(":")
        patcher.save(patchelf_compatible: true)
      end
    end
  end

  test do
    system "cargo", "new", "hello_world", "--bin"
    cd "hello_world" do
      system bin/"rustfmt", "--check", "./src/main.rs"
    end

    # Make sure all the executables work after patching.
    bin.each_child { |exe| system exe, "--help" }
  end
end
