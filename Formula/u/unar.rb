class Unar < Formula
  desc "Command-line unarchiving tools supporting multiple formats"
  homepage "https://theunarchiver.com/command-line"
  url "https://github.com/MacPaw/XADMaster/archive/refs/tags/v1.10.8.tar.gz"
  sha256 "652953d7988b3c33f4f52b61c357afd1a7c2fc170e5e6e2219f4432b0c4cd39f"
  license "LGPL-2.1-or-later"
  revision 4
  head "https://github.com/MacPaw/XADMaster.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "d4b0a3b71bc47380d1943926d4a6c83a99bed46a56926f8b76a74a76acda48ae"
    sha256 cellar: :any,                 arm64_sonoma:  "9837652e6d7199c4f646a7b0f051277114de2ebcfca8697fc584bfeeca4da371"
    sha256 cellar: :any,                 arm64_ventura: "833640682b2af5f3efbdf529ddf4cbe142e3d393a3b5731dee82c0e852cc9bf7"
    sha256 cellar: :any,                 sonoma:        "5280a2f2372afc63774151b2d317d808c3b7364d66b302ad66d54604a11dd86f"
    sha256 cellar: :any,                 ventura:       "3e631ff43685b02c54e4e97a3aa478ceadd50eb46ec8382a5e32e7fe10204d49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91434ce00eb53726ccecd0958606598d911e396a5e09e65d9e55f05340adb81c"
  end

  depends_on xcode: :build

  uses_from_macos "llvm" => :build
  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "gnustep-base"
    depends_on "icu4c@76"
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
      bash_completion.install "unar.bash_completion" => "unar"
      bash_completion.install "lsar.bash_completion" => "lsar"
    end
  end

  test do
    cp prefix/"README.md", "."
    system "gzip", "README.md"
    assert_equal "README.md.gz: Gzip\nREADME.md\n", shell_output("#{bin}/lsar README.md.gz")
    system bin/"unar", "README.md.gz"
    assert_path_exists testpath/"README.md"
  end
end
