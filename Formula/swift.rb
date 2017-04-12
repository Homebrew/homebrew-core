class Swift < Formula
  desc "High-performance system programming language"
  homepage "https://github.com/apple/swift"

  # This formula is expected to have broken/missing linkage to
  # both UIKit.framework and AssetsLibrary.framework. This is
  # simply due to the nature of Swift's SDK Overlays.
  stable do
    url "https://github.com/apple/swift/archive/swift-3.1-RELEASE.tar.gz"
    sha256 "bc8f4fc1cb5e9cddcdca4208dc5db89696d6ab507e739d498519a0262bd453c0"

    resource "clang" do
      url "https://github.com/apple/swift-clang/archive/swift-3.1-RELEASE.tar.gz"
      sha256 "bb4543904e82f433a6a65612c9c4d8218dc5358f8097318f4f7fd6af145dd1f5"
    end

    resource "cmark" do
      url "https://github.com/apple/swift-cmark/archive/swift-3.1-RELEASE.tar.gz"
      sha256 "f0906c6048cdc93c85106090a878dea7ca3b6d862091f82fe8073e273d3fc011"
    end

    resource "compiler-rt" do
      url "https://github.com/apple/swift-compiler-rt/archive/swift-3.1-RELEASE.tar.gz"
      sha256 "d1d4eec2649f9c02007f666975b41bb0174713384c80665f15e7f34345049d96"
    end

    resource "llbuild" do
      url "https://github.com/apple/swift-llbuild/archive/swift-3.1-RELEASE.tar.gz"
      sha256 "578c0d28fc74df52c77dd6c1bfc91e45f0d9d2349e82855ae2f9715d1b25ac36"
    end

    resource "llvm" do
      url "https://github.com/apple/swift-llvm/archive/swift-3.1-RELEASE.tar.gz"
      sha256 "5f99110ac0fcd70b7fabf02989cfd0e7f1f1b6368b80d69f1506ce1fdc38c83e"
    end

    resource "swiftpm" do
      url "https://github.com/apple/swift-package-manager/archive/swift-3.1-RELEASE.tar.gz"
      sha256 "54e66ff2fbe06011207e07a75807b9c0d317355c655c1d74580411e705f2b824"
    end
  end

  bottle do
    sha256 "99aad195f9e873da1510b7660bf064719081f1e645d43488177f5ed984e841dd" => :sierra
    sha256 "aedb8c8af6aa435da8d83c1461da1cca2d9d9369a61304aa425053a59eab1e87" => :el_capitan
  end

  keg_only :provided_by_osx, "Apple's CLT package contains Swift."

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  # Depends on latest version of Xcode
  # https://github.com/apple/swift#system-requirements
  depends_on :xcode => ["8.3", :build]

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
    (testpath/"test.swift").write <<-EOS.undent
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
