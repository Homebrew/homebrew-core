class When < Formula
  desc "Tiny personal calendar"
  homepage "https://www.lightandmatter.com/when/when.html"
  url "https://github.com/bcrowell/when/archive/1.1.44.tar.gz"
  sha256 "de8334d97a106b9e3aad42d0a169e46e276db0935b3e4239403730eadcb41cbb"
  license "GPL-2.0-only"
  head "https://github.com/bcrowell/when.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "132c7a507ca3f7e5984eb87f804a69a93d01501327d64ce9866a57ee23a8af6e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "132c7a507ca3f7e5984eb87f804a69a93d01501327d64ce9866a57ee23a8af6e"
    sha256 cellar: :any_skip_relocation, monterey:       "132c7a507ca3f7e5984eb87f804a69a93d01501327d64ce9866a57ee23a8af6e"
    sha256 cellar: :any_skip_relocation, big_sur:        "132c7a507ca3f7e5984eb87f804a69a93d01501327d64ce9866a57ee23a8af6e"
    sha256 cellar: :any_skip_relocation, catalina:       "2f9df2c93da3424c51eb901c46f847a99ba1f4c025a2759bd36c467ed9e0eeaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6f757cbf95f81a1f836702132f50e5c782f9be02069f4df3ce4e93a5012dd0c"
  end

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    (testpath/".when/preferences").write <<~EOS
      calendar = #{testpath}/calendar
    EOS

    (testpath/"calendar").write "2015 April 1, stay off the internet"
    system bin/"when", "i"
  end
end
