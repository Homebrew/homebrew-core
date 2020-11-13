class Swift < Formula
  desc "High-performance system programming language"
  homepage "https://swift.org"
  # NOTE: Keep version in sync with resources below
  url "https://github.com/apple/swift/archive/swift-5.2.5-RELEASE.tar.gz"
  sha256 "2353bb00dada11160945729a33af94150b7cf0a6a38fbe975774a6e244dbc548"
  license "Apache-2.0"
  revision 1

  livecheck do
    url "https://swift.org/download/"
    regex(/Releases<.*?>Swift v?(\d+(?:\.\d+)+)</im)
  end

  bottle do
    sha256 "26e59645661eaeea4b9c59deea4dd5591dedce7c74b20c772f2e82ab3450d678" => :catalina
    sha256 "b49fe185bb64ab86515c9b51d43046aad807fa70e49668a403385a72cc4a70b7" => :mojave
  end

  keg_only :provided_by_macos

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  # Has strict requirements on the minimum version of Xcode
  # https://github.com/apple/swift/tree/swift-#{version}-RELEASE#system-requirements
  depends_on xcode: ["11.2", :build]

  uses_from_macos "icu4c"

  resource "llvm-project" do
    url "https://github.com/apple/llvm-project/archive/swift-5.2.5-RELEASE.tar.gz"
    sha256 "f3e6bf2657edf7c290befdfc9d534ed776c0f344c0df373ccecc60ab2c928a51"
  end

  resource "cmark" do
    url "https://github.com/apple/swift-cmark/archive/swift-5.2.5-RELEASE.tar.gz"
    sha256 "71ef5641ebbb60ddd609320bdbf4d378cdcd89941b6f17f658ee5be40c98a232"
  end

  resource "llbuild" do
    url "https://github.com/apple/swift-llbuild/archive/swift-5.2.5-RELEASE.tar.gz"
    sha256 "07db561275697634f4790d9cd7d817272ffa37ebd7a69e0abc5de51bcdb4efb7"
  end

  resource "swiftpm" do
    url "https://github.com/apple/swift-package-manager/archive/swift-5.2.5-RELEASE.tar.gz"
    sha256 "f7197556bf299f4fc7b88e63fed78797fd85f94bf590f34e3de845ad5e62afbe"
  end

  resource "indexstore-db" do
    url "https://github.com/apple/indexstore-db/archive/swift-5.2.5-RELEASE.tar.gz"
    sha256 "cefe69f9b63869acee0564d38d8eb98f449647db9c8df7cd1c59538f506e7f1e"
  end

  resource "sourcekit-lsp" do
    url "https://github.com/apple/sourcekit-lsp/archive/swift-5.2.5-RELEASE.tar.gz"
    sha256 "2cb2dffc585a068cefa3bf33d873394f3bccddf8e5e7269889d6960f387ddcfc"
  end

  def install
    workspace = buildpath.parent
    build = workspace/"build"

    toolchain_prefix = "/Swift-#{version}.xctoolchain"
    install_prefix = "#{toolchain_prefix}/usr"

    ln_sf buildpath, workspace/"swift"
    resources.each { |r| r.stage(workspace/r.name) }

    mkdir build do
      # List of components to build
      swift_components = %w[
        compiler clang-resource-dir-symlink stdlib sdk-overlay
        tools editor-integration toolchain-tools license
        sourcekit-xpc-service swift-remote-mirror
        swift-remote-mirror-headers parser-lib
      ]
      llvm_components = %w[
        llvm-cov llvm-profdata IndexStore clang
        clang-resource-headers compiler-rt clangd
      ]

      args = %W[
        --release --assertions
        --no-swift-stdlib-assertions
        --build-subdir=#{build}
        --llbuild --swiftpm
        --indexstore-db --sourcekit-lsp
        --jobs=#{ENV.make_jobs}
        --verbose-build
        --
        --workspace=#{workspace}
        --install-destdir=#{prefix}
        --toolchain-prefix=#{toolchain_prefix}
        --install-prefix=#{install_prefix}
        --host-target=macosx-x86_64
        --stdlib-deployment-targets=macosx-x86_64
        --build-swift-dynamic-stdlib
        --build-swift-dynamic-sdk-overlay
        --build-swift-stdlib-unittest-extra
        --install-swift
        --swift-install-components=#{swift_components.join(";")}
        --llvm-install-components=#{llvm_components.join(";")}
        --install-llbuild
        --install-swiftpm
        --install-sourcekit-lsp
      ]

      system "#{workspace}/swift/utils/build-script", *args
    end
  end

  def caveats
    <<~EOS
      The toolchain has been installed to:
        #{opt_prefix}/Swift-#{version}.xctoolchain

      You can find the Swift binary at:
        #{opt_prefix}/Swift-#{version}.xctoolchain/usr/bin/swift

      You can also symlink the toolchain for use within Xcode:
        ln -s #{opt_prefix}/Swift-#{version}.xctoolchain ~/Library/Developer/Toolchains/Swift-#{version}.xctoolchain
    EOS
  end

  test do
    (testpath/"test.swift").write <<~'EOS'
      let base = 2
      let exponent_inner = 3
      let exponent_outer = 4
      var answer = 1

      for _ in 1...exponent_outer {
        for _ in 1...exponent_inner {
          answer *= base
        }
      }

      print("(\(base)^\(exponent_inner))^\(exponent_outer) == \(answer)")
    EOS
    output = shell_output("#{prefix}/Swift-#{version}.xctoolchain/usr/bin/swift -v test.swift")
    assert_match "(2^3)^4 == 4096\n", output
  end
end
