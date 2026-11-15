class Unar < Formula
  desc "Command-line unarchiving tools supporting multiple formats"
  homepage "https://theunarchiver.com/command-line"
  url "https://github.com/MacPaw/XADMaster/archive/refs/tags/v1.10.8.tar.gz"
  sha256 "652953d7988b3c33f4f52b61c357afd1a7c2fc170e5e6e2219f4432b0c4cd39f"
  license "LGPL-2.1-or-later"
  revision 8
  compatibility_version 1
  head "https://github.com/MacPaw/XADMaster.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ea808be2583ab45c14d465dda2a50e4d555b2dfe5d12fbcb6810bd58076cfff0"
    sha256 cellar: :any, arm64_tahoe:       "17809eba6ca093f4496f78a9bf332e9255b06e8784293bf0f5fc98137e365a04"
    sha256 cellar: :any, arm64_sequoia:     "31c4d5dc4e3fe4e666230bf56375827fa5c5dc11768feb3c1cb58fc4be349654"
    sha256 cellar: :any, arm64_linux:       "e61076b0c6cefe43baec000cc4620661d09e99c8aaf1ea8a07ae8ed967c1e60b"
    sha256 cellar: :any, x86_64_linux:      "83f1b81ca27a4bca4f70da935bbfafa457d37608ba05a410b9a640c1970d2dc5"
  end

  uses_from_macos "llvm" => :build
  uses_from_macos "bzip2"

  on_macos do
    depends_on xcode: :build
  end

  on_linux do
    depends_on "gnustep-base"
    depends_on "icu4c@79"
    depends_on "libobjc2"
    depends_on "wavpack"
    depends_on "zlib-ng-compat"
  end

  fails_with :gcc do
    cause "GCC Objective-C support is insufficient"
  end

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
