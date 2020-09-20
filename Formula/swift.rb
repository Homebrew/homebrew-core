class Swift < Formula
  desc "High-performance system programming language"
  homepage "https://swift.org"
  # NOTE: Keep version in sync with resources below
  url "https://github.com/apple/swift/archive/swift-5.3.2-RELEASE.tar.gz"
  sha256 "2087bb002dfef7ea2d7fbfaa097eeafd10d997cae52e2f34bb115fca68dd8039"
  license "Apache-2.0"

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
  depends_on xcode: ["12.0", :build]

  uses_from_macos "icu4c"

  resource "llvm-project" do
    url "https://github.com/apple/llvm-project/archive/swift-5.3.2-RELEASE.tar.gz"
    sha256 "838e41803613ce4890f4259eef1d99ee4cf1b7cbdf1c664e04e4958863999b38"
  end

  resource "cmark" do
    url "https://github.com/apple/swift-cmark/archive/swift-5.3.2-RELEASE.tar.gz"
    sha256 "d20bc09a2c76c3fb161886025334cb7e3e9884037ad91d2fa4b42ef36dfee958"
  end

  resource "llbuild" do
    url "https://github.com/apple/swift-llbuild/archive/swift-5.3.2-RELEASE.tar.gz"
    sha256 "296cee1a19c17375877d88084e20e5d98bcc7a87950f3ade143c0222439f1c9d"

    patch do
      url "https://raw.githubusercontent.com/vgorloff/swift-everywhere-toolchain/6721d91/Patches/llbuild/CMakeLists.txt.diff"
      sha256 "93fb0402e5a63d2d9e606641a91b34b054ecd1f66887847e8f2a8de724f57806"
    end
  end

  resource "swiftpm" do
    url "https://github.com/apple/swift-package-manager/archive/swift-5.3.2-RELEASE.tar.gz"
    sha256 "e62bbe51d90a93ad52b668e7a882c6a6488782b7e2a5cd74737c177882ebd681"
  end

  resource "indexstore-db" do
    url "https://github.com/apple/indexstore-db/archive/swift-5.3.2-RELEASE.tar.gz"
    sha256 "4bee784429e5dc7bbdc919eaa9a6035229636884eccb9d15ffa5d079b5aba19a"
  end

  resource "sourcekit-lsp" do
    url "https://github.com/apple/sourcekit-lsp/archive/swift-5.3.2-RELEASE.tar.gz"
    sha256 "846d4875e77874bf0a86398cf05446cfb8ed19eaa4dbcc45086c9726a7eafc89"
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
