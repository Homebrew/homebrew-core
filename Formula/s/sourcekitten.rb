class Sourcekitten < Formula
  desc "Framework and command-line tool for interacting with SourceKit"
  homepage "https://github.com/jpsim/SourceKitten"
  url "https://github.com/jpsim/SourceKitten.git",
      tag:      "0.38.0",
      revision: "821fc0eaa7c07fc98df1e9d3d43371cace697644"
  license "MIT"
  compatibility_version 1
  head "https://github.com/jpsim/SourceKitten.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b158fba55960f880a4dde1a9824d57ca3107d33080616be3ebdc2375f2026c64"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "988ca2e154bf0baeffc8558f75b72eaf273123c45f29fed462d0215fe30f50cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c333a8003a872a1c2283faf947908f1fdb8282d0a5ad007ff59979a8f3edc415"
    sha256 cellar: :any_skip_relocation, sonoma:        "3840fb11432051e881248cb0bc0186773b4f73176c279981915a21f2738866f9"
    sha256                               arm64_linux:   "c23c6d5135a62d4cb1701813810e1e218131ab408877ce5cb20bc9217195d70b"
    sha256                               x86_64_linux:  "c3cd592a6d2596a5f3ce0ed67ccd63498bcfd66f5ea4dace5fc163aef6a201b1"
  end

  uses_from_macos "swift"

  on_macos do
    depends_on xcode: ["14.0", :build]
    depends_on xcode: "6.0"
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
