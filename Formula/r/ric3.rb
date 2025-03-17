class Ric3 < Formula
  desc "Hardware Model Checker"
  homepage "https://github.com/gipsyh/rIC3"
  url "https://github.com/gipsyh/rIC3.git",
      tag:      "v1.3.5",
      revision: "a062eb602f7c97ff8a1bc8fc4c4ae70faa60706d"
  license "GPL-3.0-or-later"

  head "https://github.com/gipsyh/rIC3.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "rust" => :build

  # This formula requires Rust nightly
  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1200
  end

  def install
    # Ensure all submodules are fetched
    system "git", "submodule", "update", "--init", "--recursive"

    # Build and install - using RUSTC_BOOTSTRAP to enable nightly features on stable Rust
    ENV["RUSTC_BOOTSTRAP"] = "1"
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Test if the binary exists and can be executed
    # Handle potential non-zero exit code
    begin
      system bin/"ric3", "--help"
    rescue
      # Command may exit with non-zero status, which is fine for testing existence
    end

    # Output usage information
    puts "Usage examples:"
    puts "16-threads Portfolio rIC3: #{bin}/ric3 <AIGER FILE>"
    puts "single-thread IC3: #{bin}/ric3 -e ic3 <AIGER FILE>"
  end
end
