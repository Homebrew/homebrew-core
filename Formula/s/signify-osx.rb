class SignifyOsx < Formula
  desc "Cryptographically sign and verify files"
  homepage "https://man.openbsd.org/signify.1"
  url "https://github.com/jpouellet/signify-osx/archive/refs/tags/1.4.tar.gz"
  sha256 "5aa954fe6c54f2fc939771779e5bb64298e46d0a4ae3d08637df44c7ed8d2897"
  license "ISC"
  head "https://github.com/jpouellet/signify-osx.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "c842d35a800bb257d062f172d661077ece1018ed30363125aebbed7ee079611f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "1f645784096049b48c18e71ae3891a4430473389e52cad0c647233875bc2716b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0bfd86e88cdf725bd2e3496959793a3f4315e08f82c1de9e2c3778fc50e92c31"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "61d6a3ff6667bb16d42a052ed831e635048647d2d6bb0b0828d03a8c0b8da1cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b524debbee38eb3d651123e84189121d4249051dec29bf21c02d8e094916cdd6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "04f7c99002246fb5765666759b9a5a1f7e461a6d2d0c77e360af77951ee5de97"
    sha256 cellar: :any_skip_relocation, sonoma:         "0ca975d083283f781a14ea2681ca894d2c17cf15b9bdb77c8a0f44070022de85"
    sha256 cellar: :any_skip_relocation, ventura:        "b3118edf392c51017526fab8898c14855b9e3531fdebe3a0d98b65faf279e341"
    sha256 cellar: :any_skip_relocation, monterey:       "f3b58c34d1a01564e16b46364359f42330e1279f2a90025ce7541c9d5f69f370"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a60c4b4955d38a1effe307e2326373c069621c1135e28820783aedd5aba9788"
    sha256 cellar: :any_skip_relocation, catalina:       "74a8c2fa3d258ad59a5ab7302411a194903ea5295fbf5ecd95a43c2ac28677f4"
  end

  depends_on :macos

  def install
    system "make"
    system "make", "test"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"signify", "-G", "-n", "-p", "test.pub", "-s", "test.sec"
  end
end
