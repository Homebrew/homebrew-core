class Swift < Formula
  desc "High-performance system programming language"
  homepage "https://github.com/apple/swift"
  url "https://github.com/apple/swift/archive/swift-4.2.1-RELEASE.tar.gz"
  sha256 "1e26cf541f7b10b96344fb1c4500ec52ced525cdf7b6bb77425c768cef0b2c5b"

  bottle do
    cellar :any
    rebuild 1
    sha256 "eb739a681ff2f5b585422d3b9408dd817724eb7bc0484a31f38db6f7dc387867" => :mojave
    sha256 "1a82548cd25a4b6a525b7d8a194393e9853843e952c00c2650792141c17a528d" => :high_sierra
  end

  keg_only :provided_by_macos, "Apple's CLT package contains Swift"

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  # Depends on latest version of Xcode
  # https://github.com/apple/swift#system-requirements
  depends_on :xcode => ["10.0", :build]

  # This formula is expected to have broken/missing linkage to
  # both UIKit.framework and AssetsLibrary.framework. This is
  # simply due to the nature of Swift's SDK Overlays.
  resource "clang" do
    url "https://github.com/apple/swift-clang/archive/swift-4.2.1-RELEASE.tar.gz"
    sha256 "cbf22fe2da2e2a19010f6e109ab3f80a8af811d9416c29d031362c02a0e69a66"
  end

  resource "cmark" do
    url "https://github.com/apple/swift-cmark/archive/swift-4.2.1-RELEASE.tar.gz"
    sha256 "0e9f097c26703693a5543667716c2cac7a8847806e850db740ae9f90eaf93793"
  end

  resource "compiler-rt" do
    url "https://github.com/apple/swift-compiler-rt/archive/swift-4.2.1-RELEASE.tar.gz"
    sha256 "6b14737d2d57f3287a5c2d80d8d8ae917d8f7bbe4d78cc6d66a80e68d55cd00f"
  end

  resource "llbuild" do
    url "https://github.com/apple/swift-llbuild/archive/swift-4.2.1-RELEASE.tar.gz"
    sha256 "07a02b4314050a66fad460b76379988d794dac1452a56fcf5073d318458fed6e"
  end

  resource "llvm" do
    url "https://github.com/apple/swift-llvm/archive/swift-4.2.1-RELEASE.tar.gz"
    sha256 "bcd85a91824dd166fe852ddb7e58c509f52316011c3079010ad59b017a61ad14"
  end

  resource "swiftpm" do
    url "https://github.com/apple/swift-package-manager/archive/swift-4.2.1-RELEASE.tar.gz"
    sha256 "e1a50dc3d264bdb8d0447c264e8c164403e84b0831ffd53d87f15a742bda7fa9"
  end

  def install
    workspace = buildpath.parent
    build = workspace/"build"

    toolchain_prefix = "/Swift-#{version}.xctoolchain"
    install_prefix = "#{toolchain_prefix}/usr"

    ln_sf buildpath, "#{workspace}/swift"
    resources.each { |r| r.stage("#{workspace}/#{r.name}") }

    mkdir build do
      # List of components to build
      components = %w[
        compiler clang-resource-dir-symlink
        clang-builtin-headers-in-clang-resource-dir stdlib sdk-overlay tools
        editor-integration testsuite-tools toolchain-dev-tools license
        sourcekit-xpc-service swift-remote-mirror
        swift-remote-mirror-headers
      ]

      system "#{workspace}/swift/utils/build-script",
        "--release", "--assertions",
        "--no-swift-stdlib-assertions",
        "--build-subdir=#{build}",
        "--llbuild", "--swiftpm",
        "--",
        "--workspace=#{workspace}",
        "--build-args=-j#{ENV.make_jobs}",
        "--install-destdir=#{prefix}",
        "--toolchain-prefix=#{toolchain_prefix}",
        "--install-prefix=#{install_prefix}",
        "--host-target=macosx-x86_64",
        "--stdlib-deployment-targets=macosx-x86_64",
        "--build-swift-static-stdlib",
        "--build-swift-dynamic-stdlib",
        "--build-swift-static-sdk-overlay",
        "--build-swift-dynamic-sdk-overlay",
        "--build-swift-stdlib-unittest-extra",
        "--install-swift",
        "--swift-install-components=#{components.join(";")}",
        "--llvm-install-components=clang;libclang;libclang-headers",
        "--install-llbuild",
        "--install-swiftpm"
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
