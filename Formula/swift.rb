class Swift < Formula
  desc "High-performance system programming language"
  homepage "https://github.com/apple/swift"

  # This formula is expected to have broken/missing linkage to
  # both UIKit.framework and AssetsLibrary.framework. This is
  # simply due to the nature of Swift's SDK Overlays.
  stable do
    url "https://github.com/apple/swift/archive/swift-3.1.1-RELEASE.tar.gz"
    sha256 "03eb54e7f89109a85c9b2a9bfdee88d2d7e1bdef73ae0385b30fe4661efaf407"

    resource "clang" do
      url "https://github.com/apple/swift-clang/archive/swift-3.1.1-RELEASE.tar.gz"
      sha256 "ed41f1231bae030a412455491a5244ede53a4761617194b2dda573f5776361ad"
    end

    resource "cmark" do
      url "https://github.com/apple/swift-cmark/archive/swift-3.1.1-RELEASE.tar.gz"
      sha256 "51db8067f11976a7ca38a6ff9f173d3d9e3df290991be87835cdc003e0b62e4e"
    end

    resource "compiler-rt" do
      url "https://github.com/apple/swift-compiler-rt/archive/swift-3.1.1-RELEASE.tar.gz"
      sha256 "569568141b1f9ff0f433eaf815a0c19592bf43407bb4150d647aa9c7bc2a7c7b"
    end

    resource "llbuild" do
      url "https://github.com/apple/swift-llbuild/archive/swift-3.1.1-RELEASE.tar.gz"
      sha256 "ea59fd6603fe5d71598895832d6eef9314f1af99a72050536e473e9bb08a57df"
    end

    resource "llvm" do
      url "https://github.com/apple/swift-llvm/archive/swift-3.1.1-RELEASE.tar.gz"
      sha256 "fc6ac7c0c6afff344a8d4e5299b7417f414f1499cf374953e06c339d8177fc26"
    end

    resource "swiftpm" do
      url "https://github.com/apple/swift-package-manager/archive/swift-3.1.1-RELEASE.tar.gz"
      sha256 "5f98dd6fd41170e2f51f85131ca50cba3d50a187ce94b7a1db7a776c2815c778"
    end
  end

  bottle do
    cellar :any
    sha256 "3f856e641147d9a743dc7e978e0dab93652ad43b59a0c064af35ab679412c5ad" => :sierra
  end

  keg_only :provided_by_osx, "Apple's CLT package contains Swift"

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
