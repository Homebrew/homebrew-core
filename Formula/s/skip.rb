class Skip < Formula
  desc "Tool for building Swift apps for Android"
  homepage "https://skip.dev"
  url "https://github.com/skiptools/skip/archive/refs/tags/1.9.23.tar.gz"
  sha256 "b416b4e639ca45e636823d2342344dc5b43d016c00005cdc9324ac5ab7131da5"
  license "Apache-2.0" => { with: "Swift-exception" }
  head "https://github.com/skiptools/skip.git", branch: "main"

  bottle do
    manifest_sha256 "4edca61cc5be092192cd6ace5ac5d88f8023094b4da45ed8064ac15663a5034c"
    sha256 arm64_golden_gate: "330de528db24bec0418a5493ad206d6e51e4494a5ec783802584a5858ddeac15"
    sha256 arm64_tahoe:       "b31560b8ccf199a8bdefe319c30117bbe495f1be41ba71a204cdcbedd9b6f1ec"
    sha256 arm64_sequoia:     "7c3d7b4df7ff040b6166fc946997918fa1ebace0bc2bff29294414027b640328"
    sha256 arm64_linux:       "7f894cbf155df29866ca660d6e291408bf1f4a2f338313493486f6f1fd17a6da"
    sha256 x86_64_linux:      "d1b60a55eb40f294ad987b829b4ed65009762b6f66f814e49b130c10da8fe568"
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
