class Swift < Formula
  desc "High-performance system programming language"
  homepage "https://github.com/apple/swift"
  url "https://github.com/apple/swift/archive/swift-4.1-RELEASE.tar.gz"
  sha256 "f957f107b8e726b80c66a4902b769b0c3795e7bfde1af2e1c833948f6398acdb"

  bottle do
    cellar :any
    sha256 "73984870b76c605c219dbae7f7643471ce712e2c5ee44de2ffc09112d88539cf" => :high_sierra
  end

  keg_only :provided_by_macos, "Apple's CLT package contains Swift"

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  # Depends on latest version of Xcode
  # https://github.com/apple/swift#system-requirements
  depends_on :xcode => ["9.3", :build]

  # This formula is expected to have broken/missing linkage to
  # both UIKit.framework and AssetsLibrary.framework. This is
  # simply due to the nature of Swift's SDK Overlays.
  resource "clang" do
    url "https://github.com/apple/swift-clang/archive/swift-4.1-RELEASE.tar.gz"
    sha256 "e03c4508f714837c54da39a1c45ce78110c47428d970bbdde3ebc12068c15da2"
  end

  resource "cmark" do
    url "https://github.com/apple/swift-cmark/archive/swift-4.1-RELEASE.tar.gz"
    sha256 "21fc799d557838cc730e8e4e833cee18fea5e5733bdda6212f75c9331b9461ac"
  end

  resource "compiler-rt" do
    url "https://github.com/apple/swift-compiler-rt/archive/swift-4.1-RELEASE.tar.gz"
    sha256 "2110384f8cfa97334d4b9a2a17b1966b286189fb3a1526db8f2382c8872df189"
  end

  resource "llbuild" do
    url "https://github.com/apple/swift-llbuild/archive/swift-4.1-RELEASE.tar.gz"
    sha256 "88f2451e8c78a27ea18379b0062eb8e4fc961fca3089b5d485b6ceaeb7f67360"
  end

  resource "llvm" do
    url "https://github.com/apple/swift-llvm/archive/swift-4.1-RELEASE.tar.gz"
    sha256 "c8632074d178e04abc9ab3becb40618373c1b6f810053e18ddd7ff91dbbc8a48"
  end

  resource "swiftpm" do
    url "https://github.com/apple/swift-package-manager/archive/swift-4.1-RELEASE.tar.gz"
    sha256 "fcb4f55349143b9e8ad5ba0a5237beaa93a2bc42844ebb3d85c6df8a01e14142"
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
