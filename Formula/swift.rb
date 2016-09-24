class Swift < Formula
  desc "High-performance system programming language"
  homepage "https://github.com/apple/swift"

  stable do
    url "https://github.com/apple/swift/archive/swift-2.2.1-RELEASE.tar.gz"
    sha256 "e971e2287055da72564356f369bad97e95821afb1ef36157e954a04a7e90753a"

    swift_tag = "swift-#{version}-RELEASE"
    resource "cmark" do
      url "https://github.com/apple/swift-cmark/archive/#{swift_tag}.tar.gz"
      sha256 "254d3c02bf2b03ad456fa3ad27b4da854e36318fcaf6b6f199fdb3e978a90803"
    end

    resource "clang" do
      url "https://github.com/apple/swift-clang/archive/#{swift_tag}.tar.gz"
      sha256 "40bdfa7eec0497ec69005d6a5d018b12c85aa2c0959d3408ecaaa9e34ff0415f"
    end

    resource "llvm" do
      url "https://github.com/apple/swift-llvm/archive/#{swift_tag}.tar.gz"
      sha256 "f7977e5bb275494b5dac4490afc5d634f894ba5f209f3b2dbd5b7e520fa5fce2"
    end
  end

  bottle do
    sha256 "f63f2c86b7d5aaed1c922d50e98b146d0cdc0a6437977fef519ee616ec39ac73" => :el_capitan
    sha256 "573b2120ea67319f8c398c2fa604479281b922deaa884c59b53ee0bc575765c6" => :yosemite
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
  depends_on :xcode => ["7.0", :build]

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
        "--build-jobs=#{ENV.make_jobs}"
    end
    bin.install "#{build}/swift-macosx-x86_64/bin/swift",
                "#{build}/swift-macosx-x86_64/bin/swift-autolink-extract",
                "#{build}/swift-macosx-x86_64/bin/swift-compress",
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
