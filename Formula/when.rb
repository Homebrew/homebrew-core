class When < Formula
  desc "Tiny personal calendar"
  homepage "https://www.lightandmatter.com/when/when.html"
  url "https://github.com/bcrowell/when/archive/1.1.44.tar.gz"
  sha256 "de8334d97a106b9e3aad42d0a169e46e276db0935b3e4239403730eadcb41cbb"
  license "GPL-2.0-only"
  head "https://github.com/bcrowell/when.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "005cc29f69bc43959e1702e482c33b6894bc9eec2078a96687dfd09c258fa18e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "005cc29f69bc43959e1702e482c33b6894bc9eec2078a96687dfd09c258fa18e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "005cc29f69bc43959e1702e482c33b6894bc9eec2078a96687dfd09c258fa18e"
    sha256 cellar: :any_skip_relocation, ventura:        "005cc29f69bc43959e1702e482c33b6894bc9eec2078a96687dfd09c258fa18e"
    sha256 cellar: :any_skip_relocation, monterey:       "005cc29f69bc43959e1702e482c33b6894bc9eec2078a96687dfd09c258fa18e"
    sha256 cellar: :any_skip_relocation, big_sur:        "005cc29f69bc43959e1702e482c33b6894bc9eec2078a96687dfd09c258fa18e"
    sha256 cellar: :any_skip_relocation, catalina:       "6cddc86c59d8cdf0ba79ecc974dd57705c34656891fe402b920baa07d801685c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a8266c047098f0549959cb83da63bac863f1d9c0c4cd57dff48e2c560255d69"
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
