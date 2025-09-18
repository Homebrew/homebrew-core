class Sourcekitten < Formula
  desc "Framework and command-line tool for interacting with SourceKit"
  homepage "https://github.com/jpsim/SourceKitten"
  url "https://github.com/jpsim/SourceKitten.git",
      tag:      "0.37.2",
      revision: "731ffe6a35344a19bab00cdca1c952d5b4fee4d8"
  license "MIT"
  head "https://github.com/jpsim/SourceKitten.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e270957f57aef52c0be6a8eac629ed87eb0f9af5b6e0c0068b5b96eb2e4c762"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44c64e1df133d699d98585b6e1e358c2a3e6ddb330d5d82de43b489c6e8f01bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac988164695f5e9bf5dbd42e8440601aeff80355022cddcee0e750916fca784d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7918e02dcba07a9af1934789a236722bb537b726137ae41652ac7c03bfedc07b"
    sha256 cellar: :any_skip_relocation, sonoma:        "82ca4f63f693f1d9d2c0faea72ce87456c973d3f802ea38e9f6599e4193741bd"
    sha256 cellar: :any_skip_relocation, ventura:       "ddcda8cfe8a5762582eb5472f8be3f280c602a6a64f4427aef8c21e4524ea4d5"
    sha256                               arm64_linux:   "4880dde3f371a7852b5c626c806a9d5da2d18d257a0b671513049cad446d42bd"
    sha256                               x86_64_linux:  "ecaea860a805bc12aaa65cbfb5928b327645c60a3c62115f3ea33ed40a62a2ec"
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
