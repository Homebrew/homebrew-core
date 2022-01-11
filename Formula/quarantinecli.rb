class Quarantinecli < Formula
  desc "Quarantine and manage quarantined files on macOS"
  homepage "https://github.com/Serena-io/quarantineCLI"
  url "https://github.com/Serena-io/quarantineCLI/archive/refs/tags/1.0.0.tar.gz"
  sha256 "69ab41c71ed37c5b47e7dc5ed54bde28f15eaf38c81d804f768f74fb482a28e6"
  license "MIT"

  depends_on :macos
  depends_on xcode: "12.3"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/quarantinecli"
  end

  test do
    touch "foo"
    system bin/"quarantinecli", "--quarantine", "foo"
  end
end
