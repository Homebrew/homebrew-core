class Swift < Formula
  desc "High-performance system programming language"
  homepage "https://github.com/apple/swift"
  url "https://github.com/apple/swift/archive/swift-4.1.3-RELEASE.tar.gz"
  sha256 "3b1b6666744c5d74c8581820d33a4653f241929e8c42e25a7f4354c4a7ae3b00"

  bottle do
    cellar :any
    sha256 "011ff2937d768fa1a62e436218402affca384b7a16a7c0ceca734422a7b585dc" => :high_sierra
  end

  keg_only :provided_by_macos, "Apple's CLT package contains Swift"

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  # Depends on latest version of Xcode
  # https://github.com/apple/swift#system-requirements
  depends_on :xcode => ["9.3", :build]

  # According to the official llvm readme, GCC 4.7+ is required
  fails_with :gcc_4_0
  fails_with :gcc_4_2
  ("4.3".."4.6").each do |n|
    fails_with :gcc => n
  end

  # This formula is expected to have broken/missing linkage to
  # both UIKit.framework and AssetsLibrary.framework. This is
  # simply due to the nature of Swift's SDK Overlays.
  resource "clang" do
    url "https://github.com/apple/swift-clang/archive/swift-4.1.3-RELEASE.tar.gz"
    sha256 "73001677afb29fcac692aa94b1b91ae9c99310df37b84bb00c832da4872617a4"
  end

  resource "cmark" do
    url "https://github.com/apple/swift-cmark/archive/swift-4.1.3-RELEASE.tar.gz"
    sha256 "49a8c9407a0dea12dc5377a79e76f740466b1d69eb31ff6b4979ecf5f515a583"
  end

  resource "compiler-rt" do
    url "https://github.com/apple/swift-compiler-rt/archive/swift-4.1.3-RELEASE.tar.gz"
    sha256 "d0ea7a395137cb488979570deeb63cd767c5da6af63c132f3f8ba623ffc571d3"
  end

  resource "llbuild" do
    url "https://github.com/apple/swift-llbuild/archive/swift-4.1.3-RELEASE.tar.gz"
    sha256 "15c5a8efa87343134cef485f07a9999c8d38cfbdf3cc6bc4fec9f479db5cbb1c"
  end

  resource "llvm" do
    url "https://github.com/apple/swift-llvm/archive/swift-4.1.3-RELEASE.tar.gz"
    sha256 "3d51d1b66c5706deb78e394f2751ea0bb1caa1eaf4fda61bacaaae7eafbb79be"
  end

  resource "swiftpm" do
    url "https://github.com/apple/swift-package-manager/archive/swift-4.1.3-RELEASE.tar.gz"
    sha256 "7b655c994c092bf88245775e77d4c4d39f6d880cab59b67d2290df02505ed355"
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
