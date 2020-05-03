class Swift < Formula
  desc "High-performance system programming language"
  homepage "https://swift.org"
  url "https://github.com/apple/swift/archive/swift-5.2.3-RELEASE.tar.gz"
  sha256 "609267142dee4dfc8e8b9486e70f825aa4ee8cd14ab8dd1c7aa670106ed58a4e"

  bottle do
    sha256 "59f15b07a9f1c3cf4d120d41a264b0ccbeadf720fe9ad6a758c7faa09d6eccfd" => :catalina
    sha256 "97b6b476fc7a0a538719ecd84c50d310dfb66a5d4c6fa67d79cfaddaf4504d6c" => :mojave
  end

  keg_only :provided_by_macos

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  # Has strict requirements on the minimum version of Xcode
  # https://github.com/apple/swift#system-requirements
  depends_on :xcode => ["11.2", :build]

  uses_from_macos "icu4c"

  resource "llvm-project" do
    url "https://github.com/apple/llvm-project/archive/swift-5.2.3-RELEASE.tar.gz"
    sha256 "a384315bb731d9a94bd1d0f3d5a93d66b3848a6d4809322d0fe4de8a06821535"
  end

  resource "cmark" do
    url "https://github.com/apple/swift-cmark/archive/swift-5.2.3-RELEASE.tar.gz"
    sha256 "7bb807e5fdb5706203eed156abb119c1636a3418700a9b81c086ac74b68c1e69"
  end

  resource "llbuild" do
    url "https://github.com/apple/swift-llbuild/archive/swift-5.2.3-RELEASE.tar.gz"
    sha256 "fd53dcb75e6ae7b40248fbe9f0d7aebbde2472c422c3396750d512bc3ed57547"
  end

  resource "swiftpm" do
    url "https://github.com/apple/swift-package-manager/archive/swift-5.2.3-RELEASE.tar.gz"
    sha256 "7b7e8b06072cd7f183dc0da8252ab3dcb8ee8c0107c2074a3b504af7804233f5"
  end

  resource "indexstore-db" do
    url "https://github.com/apple/indexstore-db/archive/swift-5.2.3-RELEASE.tar.gz"
    sha256 "c29efaf3e79688ff8cf62edbc04bc09befc9ee4910e5b5b7915458db5c8a181b"
  end

  resource "sourcekit-lsp" do
    url "https://github.com/apple/sourcekit-lsp/archive/swift-5.2.3-RELEASE.tar.gz"
    sha256 "8f704afa4f3cc6d9ba76d3a2de09c02fdb9342bf36b8de24867f913237399cee"
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
