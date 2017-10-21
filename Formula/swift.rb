class Swift < Formula
  desc "High-performance system programming language"
  homepage "https://github.com/apple/swift"

  # This formula is expected to have broken/missing linkage to
  # both UIKit.framework and AssetsLibrary.framework. This is
  # simply due to the nature of Swift's SDK Overlays.
  stable do
    url "https://github.com/apple/swift/archive/swift-4.0-RELEASE.tar.gz"
    sha256 "9ebd6b634baf82e69ac9f6fae5c9c979db7c7e4bc9db149b30b575e57da99b94"

    resource "clang" do
      url "https://github.com/apple/swift-clang/archive/swift-4.0-RELEASE.tar.gz"
      sha256 "d0f9a5a06074318fa237bc4847fc4a746918ab1d016e14baafc6bf17b24083d9"
    end

    resource "cmark" do
      url "https://github.com/apple/swift-cmark/archive/swift-4.0-RELEASE.tar.gz"
      sha256 "71aea066925abb92738549051cc5e91f78b588fe0f1102c64c35d7f9078f1cef"
    end

    resource "compiler-rt" do
      url "https://github.com/apple/swift-compiler-rt/archive/swift-4.0-RELEASE.tar.gz"
      sha256 "189baa8e00dca394afa8c58104c9a293ce37aebf38343c250bea36054f6f006d"
    end

    resource "llbuild" do
      url "https://github.com/apple/swift-llbuild/archive/swift-4.0-RELEASE.tar.gz"
      sha256 "2e9fe830e25c74d9597a4189132b09348fc995b2de831814a55c426198c941f4"
    end

    resource "llvm" do
      url "https://github.com/apple/swift-llvm/archive/swift-4.0-RELEASE.tar.gz"
      sha256 "6c30d7f3190b9f76fd646f2c03a093cf768c1aa7e10898ee8281bfe88ba0feeb"
    end

    resource "swiftpm" do
      url "https://github.com/apple/swift-package-manager/archive/swift-4.0-RELEASE.tar.gz"
      sha256 "fe19d370cb5fea32246bac1fd81a4c0e6932518e6e3b7fcc1913adc3b01b91e7"
    end
  end

  bottle do
    cellar :any
    sha256 "12d9b5326506e94d8d3aa49b6046c081924dd930dbb78bb22a404587788e34c6" => :high_sierra
    sha256 "db483790a2a844d2795e17567b2abfc9af3924736c3a07d4b2bba084c1120610" => :sierra
  end

  keg_only :provided_by_osx, "Apple's CLT package contains Swift"

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  # Depends on latest version of Xcode
  # https://github.com/apple/swift#system-requirements
  depends_on :xcode => ["9.0", :build]

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
