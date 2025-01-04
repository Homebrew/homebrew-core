class Zigup < Formula
  desc "Download and manage zig compilers"
  homepage "https://github.com/marler8997/zigup"
  url "https://github.com/marler8997/zigup/archive/refs/tags/v2024_05_05.tar.gz"
  sha256 "36bea57e38b7106e61095ff8625d44e0ff0821f79c0c485b36d231787b08b9a4"
  license "MIT-0"
  head do
    url "https://github.com/marler8997/zigup.git", branch: "master"
    depends_on "zig" => :build
  end

  depends_on "cmake" => :build # Required for zig build
  depends_on "llvm@17" => :build # Required for zig build
  depends_on "zstd" => :build # Required for zig build
  uses_from_macos "ncurses" => :build # Required for zig build
  uses_from_macos "zlib" => :build # Required for zig build

  # Older zig required to build tagged version
  # https://github.com/marler8997/zigup?tab=readme-ov-file#building-zigup
  resource "zig" do
    url "https://ziglang.org/download/0.12.1/zig-0.12.1.tar.xz"
    sha256 "cca0bf5686fe1a15405bd535661811fac7663f81664d2204ea4590ce49a6e9ba"
  end

  def install
    unless build.head?
      resource("zig").stage do
        ENV["NIX_LDFLAGS"] = ENV["HOMEBREW_RPATH_PATHS"].split(":").map { |p| "-rpath #{p}" }.join(" ") if OS.linux?

        args = ["-DZIG_STATIC_LLVM=ON"]
        args << "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-ld_classic" if DevelopmentTools.clang_build_version >= 1500
        if OS.linux?
          args << "-DCMAKE_C_COMPILER=#{Formula["llvm@16"].opt_bin}/clang"
          args << "-DCMAKE_CXX_COMPILER=#{Formula["llvm@16"].opt_bin}/clang++"
        end

        system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args(install_prefix: buildpath/"zig")
        system "cmake", "--build", "build"
        system "cmake", "--install", "build"
        ENV.prepend_path "PATH", buildpath/"zig/bin"
      end
    end

    system "zig", "build", "-Doptimize=ReleaseSafe"
    bin.install "zig-out/bin/zigup"
  end

  test do
    assert_match "0", shell_output("#{bin}/zigup -h; echo $?")
  end
end
