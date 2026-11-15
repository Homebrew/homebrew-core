class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code"
  homepage "https://github.com/krzysztofzablocki/Sourcery"
  url "https://github.com/krzysztofzablocki/Sourcery/archive/refs/tags/2.4.1.tar.gz"
  sha256 "6ed3b89e22dd9612d0558b75e47117edcfc745acf1825dade151fcc0c085afb2"
  license "MIT"
  version_scheme 1
  head "https://github.com/krzysztofzablocki/Sourcery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e1b536836e2d8850e44b9a818b0d3709aad05e99abe6bd53fa467977917fcd5e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2286ce97036b0091e5037ef08773fbb18efc1ff0f5723710b2d97e395d6ab667"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "53a201824024b709f9c39167ab4636edfabd0d58f50e1d5262ad308caf151220"
    sha256                               arm64_linux:       "e4c004c754ad37efb97f8397c08880e9ab93506e7a2596156e8ddc98567ac310"
    sha256                               x86_64_linux:      "5a1a609457bc912e1e98ee55d81e99a7df9e8fae3a13335270a690e195543563"
  end

  uses_from_macos "ruby" => :build
  uses_from_macos "swift" => :build, since: :sonoma # swift 5.10+
  uses_from_macos "curl"
  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "sqlite"
  uses_from_macos "swift"

  on_macos do
    depends_on xcode: "14.3"
  end

  deny_network_access!

  def fetch
    # SwiftPM tries to apply its own sandbox, which cannot nest inside the
    # build sandbox; Homebrew's sandbox still confines the whole process.
    # The Rakefile builds with `--build-path build/`; resolve into the same
    # SwiftPM scratch path so the checkouts are found offline.
    system "swift", "package", "resolve", "--disable-sandbox", "--build-path", "build/"
  end

  def install
    # Build script is unfortunately not customisable.
    # We want static stdlib on Linux as the stdlib is not ABI stable there
    # and use our ld shim to help find Homebrew libraries.
    # Swift Build bypasses our compiler and linker shims, so use the native build system.
    if OS.linux?
      inreplace "Rakefile", "--disable-sandbox",
                "--build-system native --static-swift-stdlib -Xswiftc -use-ld=ld"
    end

    system "rake", "build"
    bin.install "cli/bin/sourcery"
    lib.install Dir["cli/lib/*.dylib"]
  end

  test do
    # Regular functionality requires a non-sandboxed environment, so we can only test version/help here.
    assert_match version.to_s, shell_output("#{bin}/sourcery --version").chomp
  end
end
