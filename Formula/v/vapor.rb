class Vapor < Formula
  desc "Command-line tool for Vapor (Server-side Swift web framework)"
  homepage "https://vapor.codes"
  url "https://github.com/vapor/toolbox/archive/18.7.4.tar.gz"
  sha256 "59096131260d5713c31b6beedb780ac22ecdeae9e2bd7a11dd731e30a7ac261b"
  license "MIT"
  head "https://github.com/vapor/toolbox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d4dcd9e75d62519c9cddd13cd61552fcccbac11f4468e6dc76dd34f9c6614f56"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "750f0daf1a45df5513c1a819df0ef56179876bda6f0116379391e8a899077d29"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d65d9c2cba964435c5529882a27d3101b1ea368d84eef6517538c4cbcb0fbecf"
    sha256 cellar: :any_skip_relocation, sonoma:         "e5c811b1c6939b08629111ca2f4b84f7e51393634054b64a2ddc3d41305881a6"
    sha256 cellar: :any_skip_relocation, ventura:        "1291256a8f8e67132d350ab839c8c724a57089773002b3e50f5414a08a618691"
    sha256 cellar: :any_skip_relocation, monterey:       "0a7f7a6f06504678bf019db5d01d3d5853066071fb1881960616c37b2441f664"
    sha256                               x86_64_linux:   "5b069c59805953c0c6c3b75725b0dae8ab2fb19de966ad4e454d078628c0ed01"
  end

  # vapor requires Swift 5.6.0
  depends_on xcode: "13.3"

  uses_from_macos "swift", since: :big_sur

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "-Xswiftc",
      "-cross-module-optimization", "--enable-test-discovery"
    mv ".build/release/vapor", "vapor"
    bin.install "vapor"
  end

  test do
    system bin/"vapor", "new", "hello-world", "-n"
    assert_predicate testpath/"hello-world/Package.swift", :exist?
  end
end
