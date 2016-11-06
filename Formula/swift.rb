class Swift < Formula
  desc "High-performance system programming language"
  homepage "https://github.com/apple/swift"

  stable do
    url "https://github.com/apple/swift/archive/swift-3.0.1-RELEASE.tar.gz"
    sha256 "5770cc45fe352d8a96d35ee35222cba0a47883b057e012a5464d411898afa074"

    swift_tag = "swift-#{version}-RELEASE"
    resource "cmark" do
      url "https://github.com/apple/swift-cmark/archive/#{swift_tag}.tar.gz"
      sha256 "07c8d491735cc0bef3a7f8796f9eff5e52011b85e025084721fbc896a469cddb"
    end

    resource "clang" do
      url "https://github.com/apple/swift-clang/archive/#{swift_tag}.tar.gz"
      sha256 "470e3c735a675aa37f58e4fe206a2d4141478a318dcb78c3fc8121e087e782b4"
    end

    resource "llvm" do
      url "https://github.com/apple/swift-llvm/archive/#{swift_tag}.tar.gz"
      sha256 "5cfaa08743b29e6c8a948654b71fef608a48953b3eb928c3049c07ca279275c9"
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
