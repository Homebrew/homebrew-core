class Vttest < Formula
  desc "Test compatibility of VT100-compatible terminals"
  homepage "https://invisible-island.net/vttest/"
  url "https://invisible-mirror.net/archives/vttest/vttest-20241208.tgz"
  sha256 "8fee3bac7e87d4aa4a217bd2b38ab9910c3b8cf9a605b450c76ccc0ad2a6519d"
  license "BSD-3-Clause"

  livecheck do
    url "https://invisible-mirror.net/archives/vttest/"
    regex(/href=.*?vttest[._-]v?(\d+(?:[.-]\d+)*)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a4a0aeb7d6b51f67003a4c244abed71bd83ec1ad5cd074cb3ccfd2d1fbef1301"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c0bf421235c658ec8217bcb7a68799df68c5f060b05940bb20f97e7fb43a7b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7cdb02a9f59bf22b59a6efb440d27427e380fb411d7408b2cece68856c120ca8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5ce70a33f514b64a73dd2012c56b0654a599cae4df45d7987f76ae50f6c84a6c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6297dcf4f42e03066edf5ecf2440a4c40e19a63a57f3dd1857600adeb29422c"
    sha256 cellar: :any_skip_relocation, ventura:       "1fa08429b674d918c8e3c4f68c070228f155fce751bfde191875b65f34a455de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a961a2d59fc8e50c696c22fa6b129751d3c8eefbff8778abd51f6c67597d31ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0e0ebc43609027dc1615b1b71dd18f1d4a7e662cee41e3cd57ea480130f5205"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vttest -V")
  end
end
