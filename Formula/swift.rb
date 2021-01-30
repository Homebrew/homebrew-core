class Swift < Formula
  desc "High-performance system programming language"
  homepage "https://swift.org"
  # NOTE: Keep version in sync with resources below
  url "https://github.com/apple/swift/archive/swift-5.3.3-RELEASE.tar.gz"
  sha256 "f32b9dd541fbf3a412123138eb8aaf0fa793d866779c6c3cd5df6621788258c3"
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
    url "https://github.com/apple/llvm-project/archive/swift-5.3.3-RELEASE.tar.gz"
    sha256 "fe3fb21653263c3dd4b9e02794169445f5460751b155a4c7277a37145ce057f3"
  end

  resource "cmark" do
    url "https://github.com/apple/swift-cmark/archive/swift-5.3.3-RELEASE.tar.gz"
    sha256 "24316b173df877c02ea6f3a080b2bf69e8b644a301d3510e9c13fa1059b279e9"
  end

  resource "llbuild" do
    url "https://github.com/apple/swift-llbuild/archive/swift-5.3.3-RELEASE.tar.gz"
    sha256 "560a6f12292de156be23a22ea0932f95e300443ad1d422e03a7dacb689e74e78"
  end

  resource "swiftpm" do
    url "https://github.com/apple/swift-package-manager/archive/swift-5.3.3-RELEASE.tar.gz"
    sha256 "ad79ddfff3c0bdafa28594206f02ac22956a0e98067fd3fc546c355b9e571c5a"
  end

  resource "indexstore-db" do
    url "https://github.com/apple/indexstore-db/archive/swift-5.3.3-RELEASE.tar.gz"
    sha256 "79ce1a357965767f0d87af7eb9206ade480c9597c987b874e3c924127b6e509a"
  end

  resource "sourcekit-lsp" do
    url "https://github.com/apple/sourcekit-lsp/archive/swift-5.3.3-RELEASE.tar.gz"
    sha256 "b6e07c1dfb295bd80b25dce6a9b457b0db0fe507e1da3818070ac1a5ffa785e8"
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
