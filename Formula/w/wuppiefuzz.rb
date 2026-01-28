class Wuppiefuzz < Formula
  desc "Coverage-guided REST API fuzzer developed on top of LibAFL"
  homepage "https://github.com/TNO-S3/WuppieFuzz"
  url "https://github.com/TNO-S3/WuppieFuzz/releases/download/v1.4.1/source.tar.gz"
  sha256 "3bab829967b0998cab71ecb32c1bd5a7d5592a31ff0294097a172e62da8dcb71"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88b347a48043a9fabed637be5f76981c331d097e060ef44cf3070c84cf7e96d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e651f22d76f01e20450caa44a8fe62e62e8f81c4695cbbf8edc8f501df16c11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a228bf77c3a643b39b536f39a9bd94c87ddc4f4ff86b2e5010182a1aed076a58"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2d6b8dbde82e1d2a46c2db9eec1d2ee004b27483db72287a0b18c6692246d52"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71fae217d613f5ef1948b7e531bca70a2229703cee391296e9676984a7ecc1e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d75da71f6e2e2be6b0fac2cd7657442dfb755626dcbe7c5f329d46943435a07"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "sqlite"
  depends_on "z3"

  uses_from_macos "llvm" => :build # for libclang

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Drop vendored features for openssl, rusqlite and z3 to use Homebrew-provided libraries
    inreplace "Cargo.toml" do |s|
      s.gsub!(
        /^(\s*openssl\s*=\s*\{[^}]*?),\s*features\s*=\s*\[\s*"vendored"\s*\]([^}]*\})\s*$/,
        '\1\2',
      )

      s.gsub!(
        /^(\s*rusqlite\s*=\s*\{[^}]*?),\s*features\s*=\s*\[\s*"bundled"\s*\]([^}]*\})\s*$/,
        '\1\2',
      )

      s.gsub!(
        /^(\s*z3\s*=\s*\{[^}]*?),\s*features\s*=\s*\[\s*"bundled"\s*\]([^}]*\})\s*$/,
        '\1\2',
      )
    end

    ENV["Z3_LIBRARY_PATH_OVERRIDE"] = Formula["z3"].opt_lib
    ENV["Z3_SYS_Z3_HEADER"] = Formula["z3"].opt_include/"z3.h"
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["z3"].opt_lib/"pkgconfig"

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wuppiefuzz version")

    (testpath/"openapi.yaml").write <<~YAML
      openapi: 3.0.0
    YAML

    output = shell_output("#{bin}/wuppiefuzz fuzz openapi.yaml 2>&1", 1)
    assert_match "Error: Error parsing OpenAPI-file at openapi.yaml", output
  end
end
