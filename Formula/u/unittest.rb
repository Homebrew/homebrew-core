class Unittest < Formula
  desc "C++ Unit Test Framework"
  homepage "https://unittest.red-bean.com/"
  url "https://unittest.red-bean.com/tar/unittest-0.50-62.tar.gz"
  sha256 "9586ef0149b6376da9b5f95a992c7ad1546254381808cddad1f03768974b165f"
  license "BSD-3-Clause"

  livecheck do
    url "https://unittest.red-bean.com/tar/"
    regex(/href=.*?unittest[._-]v?(\d+(?:[.-]\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "1dca828fc584f8c03ad644362e528a803710f424773a437bb3cd22a28356cec4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "21c093f62ed5f62198f1a5275ea0e1793db566cdf0b6893e0a153a84ed41253f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "22d12ce92d27e2c6b3b1c137d6193c4295c6aadb4dd658fe0ee10822ca130367"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c301be0c1a8cabb9339ce5f1a2284c6c9d7c54a3f9458f92563d388ec418f0b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc9de7f5271e4a57ce5f2bd565924006f39ebb8f136ba5f4493778007c019ff5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2da59f3f0206902816c2dac6c273768858f092eb917b696b0a8b04096ea97007"
    sha256 cellar: :any_skip_relocation, sonoma:         "e99414011e169671d5946a628027bc27c4a76d633cd658524d5adaf9a5fccfae"
    sha256 cellar: :any_skip_relocation, ventura:        "a6600c783f2a191f11bb0f4b8f236819216ee20e2d4610bcc006a4478a706ded"
    sha256 cellar: :any_skip_relocation, monterey:       "d83feaeec071b449126875572d29d4df64580c06c2f4a8fcc4fca55a5c68c7f4"
    sha256 cellar: :any_skip_relocation, big_sur:        "8f449bf2ba73aaf03dd8316d6057639bd2c3a38ef347157f3721cbabfb60212f"
    sha256 cellar: :any_skip_relocation, catalina:       "ef8f5c6e18c32b813cb825ce467a6997592dca4762833f8e03f156629ffa74f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "fc7cca539bea1e17f6eb787a2061ee632cbde672e48ddb1f551a5802eab80b01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "253282b6d8bd11e9b124dea0b9356211b422502f0e809cd2f043f791275d7459"
  end

  def install
    ENV.append "CXX", "-std=c++03"
    system "./configure", *std_configure_args
    system "make", "install"
    pkgshare.install "test/unittesttest"
  end

  test do
    system "#{pkgshare}/unittesttest"
  end
end
