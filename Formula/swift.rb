class Swift < Formula
  desc "High-performance system programming language"
  homepage "https://swift.org"
  url "https://github.com/apple/swift/archive/swift-5.2.4-RELEASE.tar.gz"
  sha256 "94c44101c3dd6774887029110269bbaf9aff68cce5ea0783588157cc08d82ed8"

  bottle do
    sha256 "3ab59265cd42fb656737cddfa4a31012d50762526623a7ccb6655846e9609398" => :catalina
    sha256 "62f5bf3be8b993ce5647d768b232edfec4bb908cbc87d01002caeff14757d32d" => :mojave
  end

  keg_only :provided_by_macos

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  # Has strict requirements on the minimum version of Xcode
  # https://github.com/apple/swift#system-requirements
  depends_on :xcode => ["11.2", :build]

  uses_from_macos "icu4c"

  resource "llvm-project" do
    url "https://github.com/apple/llvm-project/archive/swift-5.2.4-RELEASE.tar.gz"
    sha256 "e36edc6c19e013a81b9255e329e9d6ffe7dfd89e8f8f23e1d931464c5f717d3a"
  end

  resource "cmark" do
    url "https://github.com/apple/swift-cmark/archive/swift-5.2.4-RELEASE.tar.gz"
    sha256 "d5f656777961390987ed04de2120e73e032713bbd7b616b5e43eb3ae6e209cb5"
  end

  resource "llbuild" do
    url "https://github.com/apple/swift-llbuild/archive/swift-5.2.4-RELEASE.tar.gz"
    sha256 "66b5374a15998a80cd72e7c1312766a8cbfe427a850f7b97d39b5d0508306e6c"
  end

  resource "swiftpm" do
    url "https://github.com/apple/swift-package-manager/archive/swift-5.2.4-RELEASE.tar.gz"
    sha256 "383bf75f6dea96c4d48b2242bd3116154365e0e032aa3dce968f2c434732446c"
  end

  resource "indexstore-db" do
    url "https://github.com/apple/indexstore-db/archive/swift-5.2.4-RELEASE.tar.gz"
    sha256 "f1a96c7c9182e6c4f43b04db4a3236b0ff3306132de305fafbdcfd36f2081da2"
  end

  resource "sourcekit-lsp" do
    url "https://github.com/apple/sourcekit-lsp/archive/swift-5.2.4-RELEASE.tar.gz"
    sha256 "6bbc728aa852a969fcab25a4ab0e1016823a0c7ec606ef3d61d0a442cfba02db"
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
