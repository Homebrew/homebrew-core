class Xcinfo < Formula
  desc "Tool to get information about and install available Xcode versions"
  homepage "https://github.com/xcodereleases/xcinfo"
  license "MIT"
  head "https://github.com/xcodereleases/xcinfo.git", branch: "master"

  stable do
    # TODO: Remove maximum_macos on the next release and update license
    url "https://github.com/xcodereleases/xcinfo/archive/refs/tags/1.0.3.tar.gz"
    sha256 "b22f56193e4de8b71bbdaf99c17cec03f291d333d095311ad7aab74b5fb50c5a"
    depends_on maximum_macos: [:sonoma, :build]
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3df6418afc61ae23e1f303b405cdf6c24dff3a0fed304e1a0a7ba9e59be44e84"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7f8d2172793446ab5a5a0e67c2257a6e7037223c9321e0f1db04dec6c84d16ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "209fabe73333978156fc9bf344645a62b1eaeaa5c9fa872ce52993f4b1717533"
    sha256 cellar: :any_skip_relocation, ventura:       "f3b5b7c1fa92151ca33febdc63092f6af054f3c8bd7f9b5fb668157bf139b19d"
  end

  depends_on xcode: ["14.2", :build]
  depends_on macos: :ventura
  depends_on :macos

  def install
    system "swift", "build",
           "--configuration", "release",
           "--disable-sandbox"
    bin.install ".build/release/xcinfo"
  end

  test do
    assert_match "12.3 RC 1 (12C33)", shell_output("#{bin}/xcinfo list --all --no-ansi")
  end
end
