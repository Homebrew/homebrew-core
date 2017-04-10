class Swift < Formula
  desc "High-performance system programming language"
  homepage "https://github.com/apple/swift"

  stable do
    url "https://github.com/apple/swift/archive/swift-3.1-RELEASE.tar.gz"
    sha256 "bc8f4fc1cb5e9cddcdca4208dc5db89696d6ab507e739d498519a0262bd453c0"

    resource "cmark" do
      url "https://github.com/apple/swift-cmark/archive/swift-3.1-RELEASE.tar.gz"
      sha256 "f0906c6048cdc93c85106090a878dea7ca3b6d862091f82fe8073e273d3fc011"
    end

    resource "clang" do
      url "https://github.com/apple/swift-clang/archive/swift-3.1-RELEASE.tar.gz"
      sha256 "bb4543904e82f433a6a65612c9c4d8218dc5358f8097318f4f7fd6af145dd1f5"
    end

    resource "llvm" do
      url "https://github.com/apple/swift-llvm/archive/swift-3.1-RELEASE.tar.gz"
      sha256 "5f99110ac0fcd70b7fabf02989cfd0e7f1f1b6368b80d69f1506ce1fdc38c83e"
    end
  end

  bottle do
    sha256 "99aad195f9e873da1510b7660bf064719081f1e645d43488177f5ed984e841dd" => :sierra
    sha256 "aedb8c8af6aa435da8d83c1461da1cca2d9d9369a61304aa425053a59eab1e87" => :el_capitan
  end

  head do
    url "https://github.com/apple/swift.git"

    resource "cmark" do
      url "https://github.com/apple/swift-cmark.git"
    end

    resource "clang" do
      url "https://github.com/apple/swift-clang.git", :branch => "stable"
    end

    resource "llvm" do
      url "https://github.com/apple/swift-llvm.git", :branch => "stable"
    end
  end

  keg_only :provided_by_osx, "Apple's CLT package contains Swift."

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

    ln_sf buildpath, "#{workspace}/swift"
    resources.each { |r| r.stage("#{workspace}/#{r.name}") }

    mkdir build do
      system "#{buildpath}/utils/build-script",
        "-R",
        "--build-subdir=",
        "--no-llvm-assertions",
        "--no-swift-assertions",
        "--no-swift-stdlib-assertions",
        "--",
        "--workspace=#{workspace}",
        "--build-args=-j#{ENV.make_jobs}",
        "--lldb-use-system-debugserver",
        "--install-prefix=#{prefix}",
        "--darwin-deployment-version-osx=#{MacOS.version}",
        "--jobs=#{ENV.make_jobs}"
    end
    bin.install "#{build}/swift-macosx-x86_64/bin/swift",
                "#{build}/swift-macosx-x86_64/bin/swift-autolink-extract",
                "#{build}/swift-macosx-x86_64/bin/swift-demangle",
                "#{build}/swift-macosx-x86_64/bin/swift-ide-test",
                "#{build}/swift-macosx-x86_64/bin/swift-llvm-opt",
                "#{build}/swift-macosx-x86_64/bin/swiftc",
                "#{build}/swift-macosx-x86_64/bin/sil-extract",
                "#{build}/swift-macosx-x86_64/bin/sil-opt"
    (lib/"swift").install "#{build}/swift-macosx-x86_64/lib/swift/macosx/",
                          "#{build}/swift-macosx-x86_64/lib/swift/shims/"
  end

  test do
    (testpath/"test.swift").write 'print("test")'
    system "#{bin}/swiftc", "test.swift"
    assert_equal "test\n", shell_output("./test")
  end
end
