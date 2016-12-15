class Swift < Formula
  desc "High-performance system programming language"
  homepage "https://github.com/apple/swift"

  stable do
    url "https://github.com/apple/swift/archive/swift-3.0.2-RELEASE.tar.gz"
    sha256 "e69764cb3d83d7209f21c2af448ae39e6612df28e37b7a3ceffa9c24f19ca0cc"

    resource "cmark" do
      url "https://github.com/apple/swift-cmark/archive/swift-3.0.2-RELEASE.tar.gz"
      sha256 "40fc49d2f1c4075030b43f706193c1e6323e741ac5b029d2c627fd2f86da1cb4"
    end

    resource "clang" do
      url "https://github.com/apple/swift-clang/archive/swift-3.0.2-RELEASE.tar.gz"
      sha256 "8c9026b6f7543fc4ad2efef412da8ab186dbbcb089e8558e27b9994243faff99"
    end

    resource "llvm" do
      url "https://github.com/apple/swift-llvm/archive/swift-3.0.2-RELEASE.tar.gz"
      sha256 "194f66f522aa349061ae682bab18fa3fffe146da30e30f2d9f4b811fd544f8eb"
    end
  end

  bottle do
    sha256 "b890e2a056a71a6e87135bfd50f0a500c81af637aa1184dca1cecf540c0f39c8" => :sierra
    sha256 "a7763860ae2420475af51e2e970148ad7353a74f6a8dbfd4e2f916cfd81de4f6" => :el_capitan
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
  depends_on :xcode => ["8.0", :build]

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
