class Swift < Formula
  desc "High-performance system programming language"
  homepage "https://github.com/apple/swift"
  url "https://github.com/apple/swift/archive/swift-4.0.3-RELEASE.tar.gz"
  sha256 "026d596dd4a24580a5e442409e8c58259197bd73ddbb77e5aade96da982ea39b"

  bottle do
    cellar :any
    sha256 "f283aa347aa58b57dd835a91f311837fcb4b8cdbea52aaf9dcffdf33b8915e0c" => :high_sierra
    sha256 "2d8f4b3bf2a3c1d5ffd811b42378cb43da9f49c0c16fec6e294d93338bfc57ad" => :sierra
  end

  keg_only :provided_by_macos, "Apple's CLT package contains Swift"

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  # Depends on latest version of Xcode
  # https://github.com/apple/swift#system-requirements
  depends_on :xcode => ["9.0", :build]

  # This formula is expected to have broken/missing linkage to
  # both UIKit.framework and AssetsLibrary.framework. This is
  # simply due to the nature of Swift's SDK Overlays.
  resource "clang" do
    url "https://github.com/apple/swift-clang/archive/swift-4.0.3-RELEASE.tar.gz"
    sha256 "c940bd48c88f71622fb00167d92a619dd1614093893e1a09982c08da42259404"
  end

  resource "cmark" do
    url "https://github.com/apple/swift-cmark/archive/swift-4.0.3-RELEASE.tar.gz"
    sha256 "e95d0b54a0e897e768c9437dd67d56ec887909d0294cf6536ba240accd0d294f"
  end

  resource "compiler-rt" do
    url "https://github.com/apple/swift-compiler-rt/archive/swift-4.0.3-RELEASE.tar.gz"
    sha256 "1c2da685e8f424cb4460ed1daaf0c308f8deff63e7a3716c8a881cef60fbc7d8"
  end

  resource "llbuild" do
    url "https://github.com/apple/swift-llbuild/archive/swift-4.0.3-RELEASE.tar.gz"
    sha256 "92001e449b54a47516086a4e7d5f575bffa2847ae1f658540b2ec6f6dee6c6e7"
  end

  resource "llvm" do
    url "https://github.com/apple/swift-llvm/archive/swift-4.0.3-RELEASE.tar.gz"
    sha256 "a611487a82636142bc1ea8ef5b21401a5c75e57fb0dbf041ef8f2e85a472db2e"
  end

  resource "swiftpm" do
    url "https://github.com/apple/swift-package-manager/archive/swift-4.0.3-RELEASE.tar.gz"
    sha256 "4c26d333a01c239de8aa96b0536b7ff7218b7a322851a7d3b3b91b59fb4ce244"
  end

  # According to the official llvm readme, GCC 4.7+ is required
  fails_with :gcc_4_0
  fails_with :gcc
  ("4.3".."4.6").each do |n|
    fails_with :gcc => n
  end

  def install
    workspace = buildpath.parent
    build = workspace/"build"

    toolchain_prefix = "/Swift-#{version}.xctoolchain"
    install_prefix = "#{toolchain_prefix}/usr"

    ln_sf buildpath, "#{workspace}/swift"
    resources.each { |r| r.stage("#{workspace}/#{r.name}") }

    mkdir build do
      system "#{buildpath}/utils/build-script",
        "--release", "--assertions",
        "--no-swift-stdlib-assertions",
        "--build-subdir=#{build}",
        "--llbuild", "--swiftpm",
        "--ios", "--tvos", "--watchos",
        "--",
        "--workspace=#{workspace}", "--build-args=-j#{ENV.make_jobs}",
        "--install-destdir=#{prefix}", "--toolchain-prefix=#{toolchain_prefix}",
        "--install-prefix=#{install_prefix}", "--host-target=macosx-x86_64",
        "--build-swift-static-stdlib", "--build-swift-dynamic-stdlib",
        "--build-swift-dynamic-sdk-overlay", "--build-swift-static-sdk-overlay",
        "--build-swift-stdlib-unittest-extra", "--install-swift",
        "--swift-install-components=compiler;clang-resource-dir-symlink;"\
        "clang-builtin-headers-in-clang-resource-dir;stdlib;sdk-overlay;tools;"\
        "editor-integration;testsuite-tools;toolchain-dev-tools;license;sourcekit-inproc;"\
        "sourcekit-xpc-service;swift-remote-mirror;swift-remote-mirror-headers",
        "--llvm-install-components=clang;libclang;libclang-headers",
        "--install-llbuild", "--install-swiftpm"
    end
  end

  test do
    (testpath/"test.swift").write <<~EOS
      let base = 2
      let exponent_inner = 3
      let exponent_outer = 4
      var answer = 1

      for _ in 1...exponent_outer {
        for _ in 1...exponent_inner {
          answer *= base
        }
      }

      print("(\\(base)^\\(exponent_inner))^\\(exponent_outer) == \\(answer)")
    EOS
    output = shell_output("#{prefix}/Swift-#{version}.xctoolchain/usr/bin/swift test.swift")
    assert_match "(2^3)^4 == 4096\n", output
  end
end
