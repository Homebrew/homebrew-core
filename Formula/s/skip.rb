class Skip < Formula
  desc "Tool for building Swift apps for Android"
  homepage "https://skip.dev"
  url "https://github.com/skiptools/skip/archive/refs/tags/1.9.21.tar.gz"
  sha256 "5b46923ed3144d0e5c0db07f6b243be32c323299eac709b4711da5b71d5669b5"
  license "Apache-2.0"
  head "https://github.com/skiptools/skip.git", branch: "main"

  bottle do
    sha256 arm64_golden_gate: "4de29b4744acf58cb43b3b616c5983fb7fa99f86e47c6bfafd1b3b023cdf1502"
    sha256 arm64_tahoe:       "3b79b64462fa66964fa40114eebc051c24da8d107b1a4933dc4961a47b458fe9"
    sha256 arm64_sequoia:     "b8cffac2cf6abf076d1d53a572006f14ee21c29be9b96fa148d5bb51c3e39bb9"
    sha256 arm64_linux:       "b9136ddc53471cd0aa5d0d10b1cfd013336c5830e68b2bc664fddeff64218a13"
    sha256 x86_64_linux:      "ba813641b37b3c29080a164690ba78ad7a01dfdbafe23b6dbe8c9d29730984d2"
  end

  depends_on "gradle"
  depends_on "openjdk"
  depends_on "swiftly"

  uses_from_macos "swift" => [:build, :test]
  uses_from_macos "curl"
  uses_from_macos "libxml2"

  on_macos do
    depends_on xcode: :build
  end

  on_linux do
    depends_on "libarchive"
    depends_on "zlib-ng-compat"
  end

  def install
    # FIXME: need to update brew as Swift 6.4.0+ doesn't use ld shim anymore
    if OS.linux?
      args = ENV["HOMEBREW_LIBRARY_PATHS"].to_s.split(":").flat_map { ["-Xlinker", "-L#{it}"] } +
             ENV["HOMEBREW_RPATH_PATHS"].to_s.split(":").flat_map { ["-Xlinker", "-rpath", "-Xlinker", it] }
    end

    system "swift", "build", "--package-path", "skipstone", "--product", "SkipRunner", *args, *std_swift_args
    bin.install "skipstone/.build/release/SkipRunner" => "skip"
    generate_completions_from_executable(bin/"skip", "--generate-completion-script")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skip version")
    system bin/"skip", "welcome"
    system bin/"skip", "init", "--no-build", "--transpiled-app", "--appid", "some.app.id", "some-app", "SomeApp"
    assert_path_exists testpath/"some-app/Package.swift"
  end
end
