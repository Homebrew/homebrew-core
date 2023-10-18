class Unar < Formula
  desc "Command-line unarchiving tools supporting multiple formats"
  homepage "https://theunarchiver.com/command-line"
  url "https://github.com/MacPaw/XADMaster/archive/refs/tags/v1.10.8.tar.gz"
  sha256 "652953d7988b3c33f4f52b61c357afd1a7c2fc170e5e6e2219f4432b0c4cd39f"
  license "LGPL-2.1-or-later"
  head "https://github.com/MacPaw/XADMaster.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "955959ff3b95599559099d55be858c42bcae51573547c605ee427bb786acce72"
    sha256 cellar: :any,                 arm64_ventura:  "8f315ded2a58518d307a5e5787294e00aa95fa2198a342349a3aafdc25bf5f9f"
    sha256 cellar: :any,                 arm64_monterey: "012f7b4535902de8ee57b62429cc78a4f3b17466a0151961410190def9b65317"
    sha256 cellar: :any,                 sonoma:         "0d691d5ca8f7bace618acba25a1831ee20adacb7f039b92e81e0b20d4c1058be"
    sha256 cellar: :any,                 ventura:        "9f618c0fedf4e290c98655e0fef4bb072506b024ce4125b63123a26a03560848"
    sha256 cellar: :any,                 monterey:       "3edcc1dafa50751632ebaa3033156ad20177195b6912f669fa4fd7db7868c41e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ddba47b3729d99ceda24f362d3173b59cafafb5ff2d775a41831cb98fd7e3227"
  end

  depends_on xcode: :build

  uses_from_macos "llvm" => :build
  uses_from_macos "bzip2"

  on_linux do
    depends_on "gnustep-base"
    depends_on "icu4c"
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
