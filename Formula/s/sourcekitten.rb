class Sourcekitten < Formula
  desc "Framework and command-line tool for interacting with SourceKit"
  homepage "https://github.com/jpsim/SourceKitten"
  url "https://github.com/jpsim/SourceKitten.git",
      tag:      "0.37.3",
      revision: "6529c17fe80dd94843a3df7ed3e6a239790d5c91"
  license "MIT"
  compatibility_version 1
  head "https://github.com/jpsim/SourceKitten.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71dca54d095d7003f38fe2080dc3d8e8d314da72781efaf03cdd59102c9ebac9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d72ada65c485a6a1d2d82eed64d5de56155db0e3dca8239fe5438815caa34ece"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d3b6c3cfd3255bfb1582329d4e9eb4087c706c87d31e293a1a323150b154e1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ad122b1a44d7336032fa6ef2336b278cc84ce58affc6ffffb56e6db80ced889"
    sha256                               arm64_linux:   "084e6b26f19c3418216080ab0f2acce96b062432bc5bf9029922b7b41c7ff00c"
    sha256                               x86_64_linux:  "674dce3aee8329342d41dcf0b513f74390979eb62b97315a4ac27843c8a46091"
  end

  depends_on xcode: ["14.0", :build]
  depends_on xcode: "6.0"

  uses_from_macos "swift"

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
