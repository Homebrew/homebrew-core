class Sourcekitten < Formula
  desc "Framework and command-line tool for interacting with SourceKit"
  homepage "https://github.com/jpsim/SourceKitten"
  url "https://github.com/jpsim/SourceKitten.git",
      tag:      "0.39.0",
      revision: "1cde6e9fb78e64f9b9d38c4992cac4f071d7eb63"
  license "MIT"
  compatibility_version 1
  head "https://github.com/jpsim/SourceKitten.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6e15a7f54eb6a633cd4cf34ba15a2bfcf7e91bda5147b76ec473b04b24bc1284"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "034e8d5f425af20fab1f554f1e1501bbee64538ea0bcbc8d2304ff4b408a4f87"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d693907284b8d624882b9c18f6e743560b325b1d4b3d4e6dc809a04d234d5062"
    sha256                               arm64_linux:       "dd176b113764b7672a3db4fa1180ae6ddff4a3dd85d9c71fcbbc312c1f3edaeb"
    sha256                               x86_64_linux:      "080a088f3ae793a818323c7cb254f5cc2135fc778880404431f5ede438f20406"
  end

  uses_from_macos "swift"

  on_macos do
    depends_on xcode: ["14.0", :build]
    depends_on xcode: "6.0" # does not support CLT sourcekitd.framework
  end

  deny_network_access!

  def fetch
    # SwiftPM tries to apply its own sandbox, which cannot nest inside the
    # build sandbox; Homebrew's sandbox still confines the whole process.
    system "swift", "package", "resolve", "--disable-sandbox"
  end

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}", "TEMPORARY_FOLDER=#{buildpath}/SourceKitten.dst"
    generate_completions_from_executable(bin/"sourcekitten", "--generate-completion-script")
  end

  test do
    system bin/"sourcekitten", "version"
    return if OS.mac? && MacOS::Xcode.version < 14

    ENV["IN_PROCESS_SOURCEKIT"] = "YES"
    system bin/"sourcekitten", "syntax", "--text", "import Foundation // Hello World"
  end
end
