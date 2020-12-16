class Xcinfo < Formula
  desc "Tool to get information about and install available Xcode versions"
  homepage "https://github.com/xcodereleases/xcinfo"
  url "https://github.com/xcodereleases/xcinfo/archive/0.5.0.tar.gz"
  sha256 "07b6c2f5a5b6a5f3cd6d190ac16c36c5011a87f2a1da2a109ccaa909eb6bcc2c"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "2e9234ff445d2673f391f0e58d7858e475d5cfb7a674fa1a2f36830b0f1d5606" => :big_sur
    sha256 "ec7dbfffbb4b2358dce4aee2961d083eae644408226bf2391fa8b736db6b0cd6" => :catalina
  end

  depends_on xcode: ["12.0", :build]
  depends_on macos: :catalina

  def install
    system "swift", "build",
           "--configuration", "release",
           "--disable-sandbox"
    bin.install ".build/release/xcinfo"
  end

  test do
    assert_match /12.3 RC 1 \(12C33\)/, shell_output("#{bin}/xcinfo list --all --no-ansi")
  end
end
