class Unar < Formula
  desc "Command-line unarchiving tools supporting multiple formats"
  homepage "https://unarchiver.c3.cx/commandline"
  url "https://wakaba.c3.cx/releases/TheUnarchiver/unar1.10.1_src.zip"
  version "1.10.1"
  sha256 "40967014a505b7a27864c49dc3b5d30b98ae4e6d4873783b2ef9ef9215fd092b"
  head "https://bitbucket.org/WAHa_06x36/theunarchiver", :using => :hg

  bottle do
    cellar :any
    rebuild 1
    sha256 "5a9fc27b0ced42e4bd8fabc4e21b8a4b4237f18329e424d07d56e2281fec0efd" => :catalina
    sha256 "da43cef8fa866f3ef1b49207616198f71865a2bd74bea8a4ca6561663c8c5a4a" => :mojave
    sha256 "83d44f348e559ec06bea6a5e9d9b50252884b2f9eefda0d0834f4b43f9445049" => :high_sierra
    sha256 "26a7dc14db6b28cc896f5692fd1ba6b3434656c80df5e28fecb41dfa952f31d8" => :sierra
  end

  depends_on :xcode => :build

  # Fix build for Xcode 10 but remove libstdc++.6.dylib and linking libc++.dylib instead
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/a94f6f/unar/xcode10.diff"
    sha256 "d4ac4abe6f6bcc2175efab6be615432b5a8093f8bfc99fba21552bc820b29703"
  end

  def install
    # ZIP for 1.10.1 additionally contains a `__MACOSX` directory, preventing
    # stripping of the first path component during extraction of the archive.
    mv Dir["The Unarchiver/*"], "."

    args = %W[
      -project ./XADMaster/XADMaster.xcodeproj
      SYMROOT=..
      -configuration Release
      MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}
    ]

    # Build XADMaster.framework, unar and lsar
    xcodebuild "-target", "XADMaster", *args
    xcodebuild "-target", "unar", *args
    xcodebuild "-target", "lsar", *args

    bin.install "./Release/unar", "./Release/lsar"
    lib.install "./Release/libXADMaster.a"
    frameworks.install "./Release/XADMaster.framework"
    (include/"libXADMaster").install_symlink Dir["#{frameworks}/XADMaster.framework/Headers/*"]

    cd "./Extra" do
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
