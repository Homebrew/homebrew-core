class Rustfmt < Formula
  desc "Format Rust code"
  homepage "https://rust-lang.github.io/rustfmt/"
  url "https://github.com/rust-lang/rustfmt/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "9f228d6192104a57efd73b20b8f0a2189c920373655b0c17b75758afab805be8"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/rust-lang/rustfmt.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0bc41425bca0cebff19f98f92d3495022438dea06b2de92a453e9273b2dae2d1"
    sha256 cellar: :any,                 arm64_ventura:  "5f5ac9dfb767b047a324ad7d30772ea0fdf2004ea07bc3d7777db50eb477ac61"
    sha256 cellar: :any,                 arm64_monterey: "fb66b78ddb10d7e4fbedd8ceadb6bb0417bb31e6b2b31f0e3b7cf52a9ca2c729"
    sha256 cellar: :any,                 sonoma:         "c308cb93a595e76d83b98a65642e6915d17258b40cb521ec3740d3399665ec01"
    sha256 cellar: :any,                 ventura:        "24df5b88193bf67304a682284246770b8210f1228f8c27eaa4e26bdc92909807"
    sha256 cellar: :any,                 monterey:       "38c30c78cd44aa19df1a045755340742174dd79cbc9857550a2fd1d087dd2395"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e93863d9f42ac0ec4bda61168758d82e2164a400ea80d929433c864728977ba"
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
