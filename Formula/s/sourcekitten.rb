class Sourcekitten < Formula
  desc "Framework and command-line tool for interacting with SourceKit"
  homepage "https://github.com/jpsim/SourceKitten"
  url "https://github.com/jpsim/SourceKitten.git",
      tag:      "0.37.2",
      revision: "731ffe6a35344a19bab00cdca1c952d5b4fee4d8"
  license "MIT"
  head "https://github.com/jpsim/SourceKitten.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34d5a49f50885b3cc0cff8812f6c4770976be709befa058385d404f27487fd06"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a68272f86ee89c1dbf1fb19349431a209124f7b2413d6a32152d81dec8978ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "07ec2e64a18e5ce87c3511be8ba93f17d162d05c737da4dc5a52c477f6e795a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c64b978d11776e2baa8103bdac80636561f69f157d203411dab05a05c87e294"
    sha256 cellar: :any_skip_relocation, ventura:       "207bcbf2c8ce58e39afa645836e7798085c39803e9ec1ba728ac80f1b7281713"
    sha256                               arm64_linux:   "53a805bb690bda85db814fb237af34c3999c8ef3685e9878562b9d0b8a38c355"
    sha256                               x86_64_linux:  "97515204398c1cd3aec85367e15eba66781a08fbb972aecb2c74a5cafb419ea6"
  end

  depends_on xcode: ["14.0", :build]
  depends_on xcode: "6.0"

  uses_from_macos "swift"

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}", "TEMPORARY_FOLDER=#{buildpath}/SourceKitten.dst"
  end

  test do
    system bin/"sourcekitten", "version"
    return if OS.mac? && MacOS::Xcode.version < 14

    ENV["IN_PROCESS_SOURCEKIT"] = "YES"
    system bin/"sourcekitten", "syntax", "--text", "import Foundation // Hello World"
  end
end
