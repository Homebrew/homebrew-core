class Sourcekitten < Formula
  desc "Framework and command-line tool for interacting with SourceKit"
  homepage "https://github.com/jpsim/SourceKitten"
  url "https://github.com/jpsim/SourceKitten.git",
      tag:      "0.37.1",
      revision: "453f75b8a3bb2c3596c0d2dd422c289788233a22"
  license "MIT"
  head "https://github.com/jpsim/SourceKitten.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89fa8c30466e846d316679364fe99dcade4132ec90d3e046defe801ced7a65c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "965d8e4948520b7dbc72faedfcb6592559c60941cd41d29ba5afba7f4d95554b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4998452b88cbcaedf772354cc6f2929eeca07515bf99a1c515451954d6a95aa4"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d6244e977d613af761b92add12ce7d41d92b32c517047ca952cde6cf36ec363"
    sha256 cellar: :any_skip_relocation, ventura:       "5b76f897e6d82093c07b4f8023e3a9dc036c3dde983555ac328c5c040b87161f"
    sha256                               arm64_linux:   "836dd867de37d2e4015b2fa33d37a1951444657c70b33ff576f3de6739db8ee4"
    sha256                               x86_64_linux:  "afd660f974dc353add28e1597ea666fb1fd7e1ce6bf03385b4e56dd22eb7b5f2"
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
