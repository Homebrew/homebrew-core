class Scriptc < Formula
  desc "Compile TypeScript and JavaScript to native executables and WebAssembly"
  homepage "https://github.com/vercel-labs/scriptc"
  url "https://github.com/vercel-labs/scriptc/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "679271ef36209760be2a83faf50b5c0e3cb987f5387881f144a1009ca632b8c9"
  license "Apache-2.0"
  head "https://github.com/vercel-labs/scriptc.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "llvm@22" => :build
  depends_on "ninja" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build
  depends_on "zig" => :build

  deny_network_access!

  def fetch
    ENV.prepend_path "PATH", formula_opt_bin("node")
    system "pnpm", "fetch"
  end

  def install
    ENV.prepend_path "PATH", formula_opt_bin("node")
    ENV["LLVM_DIR"] = formula_opt_lib("llvm@22")/"cmake/llvm"

    system "pnpm", "install", "--offline", "--frozen-lockfile"

    if OS.mac?
      helper = Hardware::CPU.arm? ? "llvm-darwin-arm64" : "llvm-darwin-x64"
      runtime = Hardware::CPU.arm? ? "runtime-darwin-arm64" : "runtime-darwin-x64"
      cli = Hardware::CPU.arm? ? "cli-darwin-arm64" : "cli-darwin-x64"
      system "pnpm", "--filter", "@scriptc/#{helper}", "build:native"
      system "pnpm", "--filter", "@scriptc/#{runtime}", "build:native"
    else
      arch = Hardware::CPU.arm? ? "arm64" : "x64"
      helper = "llvm-linux-#{arch}-gnu"
      runtime = "runtime-linux-#{arch}-gnu"
      cli = "cli-linux-#{arch}-gnu"
      inreplace "packages/#{helper}/scripts/build.mjs",
                ', "-DSCRIPTC_STATIC_LINUX_BUILD=ON", "-DCMAKE_EXE_LINKER_FLAGS=-static"', ""
      inreplace "packages/compiler/src/backend/native-codegen.ts",
                "const failure = error as NodeJS.ErrnoException & { stderr?: string; " \
                "stdout?: string };",
                "const failure = error as NodeJS.ErrnoException & { stderr?: string; " \
                "stdout?: string; signal?: NodeJS.Signals | null };"
      inreplace "packages/compiler/src/backend/native-codegen.ts",
                "const parsed = helperFailureMessage(stderr, failure.message);",
                <<~TS
                  const exitCode = (failure as unknown as { code?: number }).code;
                  const details = failure.signal
                    ? ` (${failure.signal})`
                    : typeof exitCode === "number" ? ` (exit ${exitCode})` : "";
                  const parsed = helperFailureMessage(stderr, failure.message);
                TS
      inreplace "packages/compiler/src/backend/native-codegen.ts",
                ": ${parsed.message}",
                ": ${parsed.message}${details}"
      with_env "CC" => "zig", "AR" => "zig" do
        system "pnpm", "--filter", "@scriptc/#{runtime}", "build:native"
      end
      system "pnpm", "--filter", "@scriptc/#{helper}", "build:native"
    end

    system "pnpm", "--filter", "@scriptc/compiler", "--filter", "scriptc", "build"
    system "pnpm", "--filter", "@scriptc/#{cli}", "build:native"

    cli_bin = buildpath/"packages/#{cli}/dist"
    libexec.install cli_bin/"bin", cli_bin/"lib"
    bin.install_symlink libexec/"bin/scriptc" => "scriptc"
  end

  test do
    (testpath/"hello.ts").write <<~TS
      console.log(`hello, ${process.argv[2]}`);
    TS

    system bin/"scriptc", "build", "hello.ts", "-o", "hello"
    assert_equal "hello, homebrew\n", shell_output("./hello homebrew")
  end
end
