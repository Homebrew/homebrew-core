class Swiftdraw < Formula
  desc "Convert SVG into PDF, PNG, JPEG or SF Symbol"
  homepage "https://github.com/swhitty/SwiftDraw"
  url "https://github.com/swhitty/SwiftDraw/archive/refs/tags/0.30.0.tar.gz"
  sha256 "a4684015c0dcb7cf220c7d8aa16cd86a4143c23521f51496e7eae7f3e04e3d16"
  license "Zlib"
  head "https://github.com/swhitty/SwiftDraw.git", branch: "main"

  bottle do
    manifest_sha256 "025d165205ef8503feaf6a329f0095f222ca77a7387043353bda615562491ba6"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a52e0549049f9fee1018b9090b30022335d69debb9dd7d863afbf68d11c91b94"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "40f4ebfaa9e7907381c4fe4902b41b2499f5a9adea48cdb841c941e748465126"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4e81ce9b9959db714a63b024e2b96e05097e3f16e5b79ccfde85f9ed3d8dd604"
    sha256 cellar: :any,                 arm64_linux:       "29482ccda4ff35d39ed969a4c657b4a7c266516d36c9b747a199f88fb1f74b4e"
    sha256 cellar: :any,                 x86_64_linux:      "5c2ef1629259b50216c5e334c6db6ff286870d2dc5f0bce1e42ccb78126d81a2"
  end

  uses_from_macos "swift" => :build
  uses_from_macos "libxml2"

  on_macos do
    depends_on xcode: ["16.0", :build]
  end

  deny_network_access!

  def fetch
    # SwiftPM tries to apply its own sandbox, which cannot nest inside the
    # build sandbox; Homebrew's sandbox still confines the whole process.
    system "swift", "package", "resolve", "--disable-sandbox"
  end

  def install
    args = std_swift_args
    if OS.linux?
      # Swift 6.4+ bypasses Homebrew's linker shim.
      args += ENV["HOMEBREW_LIBRARY_PATHS"].to_s.split(":").flat_map { ["-Xlinker", "-L#{it}"] } +
              ENV["HOMEBREW_RPATH_PATHS"].to_s.split(":").flat_map { ["-Xlinker", "-rpath", "-Xlinker", it] }
    end
    system "swift", "build", *args
    bin.install ".build/release/swiftdrawcli" => "swiftdraw"
  end

  test do
    (testpath/"fish.svg").write <<~SVG
      <?xml version="1.0" encoding="utf-8"?>
      <svg version="1.1" xmlns="http://www.w3.org/2000/svg" width="160" height="160">
        <path d="m 80 20 a 50 50 0 1 0 50 50 h -50 z" fill="pink" stroke="black" stroke-width="2" transform="rotate(45, 80, 80)"/>
      </svg>
    SVG
    system bin/"swiftdraw", testpath/"fish.svg", "--format", "sfsymbol"
    assert_path_exists testpath/"fish-symbol.svg"
  end
end
