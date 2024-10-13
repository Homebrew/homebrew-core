class Unar < Formula
  desc "Command-line unarchiving tools supporting multiple formats"
  homepage "https://theunarchiver.com/command-line"
  url "https://github.com/MacPaw/XADMaster/archive/refs/tags/v1.10.8.tar.gz"
  sha256 "652953d7988b3c33f4f52b61c357afd1a7c2fc170e5e6e2219f4432b0c4cd39f"
  license "LGPL-2.1-or-later"
  revision 2
  head "https://github.com/MacPaw/XADMaster.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "48c1c1e8275ea52a2a50421d11ae0bed44735352053a9b3dca74c7c20cc71200"
    sha256 cellar: :any,                 arm64_sonoma:   "4ff0ed25737fd69dffc7640a2185da60dd1be3c047ce7a2f32dcd2ee5de147af"
    sha256 cellar: :any,                 arm64_ventura:  "fce2da0774b12aa7fc18741f7748002e40fa27bfa9325c7107531a88eabebee1"
    sha256 cellar: :any,                 arm64_monterey: "c1f23406296141da895b5531199c4f093b265a75fa8db09139b7a74e7b56c367"
    sha256 cellar: :any,                 sonoma:         "454a5e3f0fc4143b931eb1b03c9c8c9368eebe6e34918c60e4a1a86c837d6759"
    sha256 cellar: :any,                 ventura:        "0ee3354104fa64d42e96c430eca72b4e29df3ccc3c96ec9b32a3156a91485b3a"
    sha256 cellar: :any,                 monterey:       "e31763ef73cf0f606908700d15066e9a5375055c651cffa074bb6f1246d28100"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afd209d4979e519ce8757b6e3223541907a8ac00e6d377302be151bc01dff5f8"
  end

  depends_on xcode: :build

  uses_from_macos "llvm" => :build
  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "gnustep-base"
    depends_on "icu4c"
    depends_on "libobjc2"
    depends_on "wavpack"
  end

  # Clang must be used on Linux because GCC Objective C support is insufficient.
  fails_with :gcc

  resource "universal-detector" do
    url "https://github.com/MacPaw/universal-detector/archive/refs/tags/1.1.tar.gz"
    sha256 "8e8532111d0163628eb828a60d67b53133afad3f710b1967e69d3b8eee28a811"
  end

  def install
    resource("universal-detector").stage buildpath/"../UniversalDetector"

    # Link to libc++.dylib instead of libstdc++.6.dylib
    inreplace "XADMaster.xcodeproj/project.pbxproj", "libstdc++.6.dylib", "libc++.1.dylib"

    # Replace usage of __DATE__ to keep builds reproducible
    inreplace %w[lsar.m unar.m], "@__DATE__", "@\"#{time.strftime("%b %d %Y")}\""

    # Makefile.linux does not support an out-of-tree build.
    if OS.mac?
      mkdir "build" do
        # Build XADMaster.framework, unar and lsar
        arch = Hardware::CPU.arm? ? "arm64" : "x86_64"
        %w[XADMaster unar lsar].each do |target|
          xcodebuild "-target", target, "-project", "../XADMaster.xcodeproj",
                     "SYMROOT=#{buildpath/"build"}", "-configuration", "Release",
                     "MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}", "ARCHS=#{arch}", "ONLY_ACTIVE_ARCH=YES"
        end

        bin.install "./Release/unar", "./Release/lsar"
        %w[UniversalDetector XADMaster].each do |framework|
          lib.install "./Release/lib#{framework}.a"
          frameworks.install "./Release/#{framework}.framework"
          (include/"lib#{framework}").install_symlink Dir["#{frameworks}/#{framework}.framework/Headers/*"]
        end
      end
    else
      system "make", "-f", "Makefile.linux"
      bin.install "unar", "lsar"
      lib.install buildpath/"../UniversalDetector/libUniversalDetector.a", "libXADMaster.a"
    end

    cd "Extra" do
      man1.install "lsar.1", "unar.1"
      bash_completion.install "unar.bash_completion", "lsar.bash_completion"
    end
  end

  test do
    cp prefix/"README.md", "."
    system "gzip", "README.md"
    assert_equal "README.md.gz: Gzip\nREADME.md\n", shell_output("#{bin}/lsar README.md.gz")
    system bin/"unar", "README.md.gz"
    assert_predicate testpath/"README.md", :exist?
  end
end
