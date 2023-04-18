class Setweblocthumb < Formula
  desc "Assigns custom icons to webloc files"
  homepage "https://hasseg.org/setWeblocThumb/"
  url "https://github.com/ali-rantakari/setWeblocThumb/archive/v1.0.0.tar.gz"
  sha256 "0258fdabbd24eed2ad3ff425b7832c4cd9bc706254861a6339f886efc28e35be"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6eb231e7fa24dcebe8d1d863bc1bbbcec86943522f4391dce30c0d0a14a99e7e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f306986d59d8d148fe8619ef3a14b12fc89235e199ab18cfd691885009cc47f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "849e242cc0d75408abb95ed3afead495868ae730132fd4a648f032ea3b873774"
    sha256 cellar: :any_skip_relocation, ventura:        "7731be759ebec8e9e06e70056f4ddc19498872cc8daafa4079baa7610a0662d0"
    sha256 cellar: :any_skip_relocation, monterey:       "20e1fe63be72e27183b5e0a5885f5456882b1a72487e72c446ae48723f793920"
    sha256 cellar: :any_skip_relocation, big_sur:        "565f0fb62158115fcd9e1618282b989bd50007f5c8c0260df5f47f85660adb87"
    sha256 cellar: :any_skip_relocation, catalina:       "6849eb0b22ee09260daa9432881f66dbb97ef44b26e1d469ca11d316658ee4f2"
    sha256 cellar: :any_skip_relocation, mojave:         "95ec7fa6fc12d232f0ce75089ec987d91a922752578447a68e9170de743d5552"
    sha256 cellar: :any_skip_relocation, high_sierra:    "8d7536c3ba30dc46c4e3a0f2e4be411d3e8b06be939a5130c67d2094da0cef4e"
    sha256 cellar: :any_skip_relocation, sierra:         "563620905a209f198f30bbffc9177294b224cee3098719af6da8cfca74092157"
    sha256 cellar: :any_skip_relocation, el_capitan:     "2a9c327d5d594d00d7d283d6627a5eeef160731616aec9d62bab017b52d71f1a"
  end

  depends_on :macos

  def install
    system "make"
    bin.install "setWeblocThumb"
  end

  test do
    Pathname.new("google.webloc").write('{URL = "https://google.com";}')
    system "#{bin}/setWeblocThumb", "google.webloc"
  end
end
