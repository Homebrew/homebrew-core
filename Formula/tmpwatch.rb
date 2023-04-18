class Tmpwatch < Formula
  desc "Find and remove files not accessed in a specified time"
  homepage "https://pagure.io/tmpwatch"
  url "https://releases.pagure.org/tmpwatch/tmpwatch-2.11.tar.bz2"
  sha256 "93168112b2515bc4c7117e8113b8d91e06b79550d2194d62a0c174fe6c2aa8d4"
  license "GPL-2.0-only"
  head "https://pagure.io/tmpwatch.git", branch: "master"

  livecheck do
    url :head
    regex(/^(?:r|tmpwatch|v)[._-]?(\d+(?:[._-]\d+)+)$/i)
    strategy :git do |tags|
      tags.map { |tag| tag[regex, 1]&.gsub(/[_-]/, ".") }.compact
    end
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d6f80858cba05532b70c7d3ae636b0c7550ef651891fef8e36b182e131662c2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aee3dbca7f86d8c80da945837cb30a43a5c55ade929df40d4c4221ca3243b954"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b5f38895989ced860baaac4a22ed677b6adc7e3eaf07ecea5e65325b3a090071"
    sha256 cellar: :any_skip_relocation, ventura:        "e09f42c2a9e80778995eb414e36f92ab3735db17cdaee935ebc206bd30b3ecb9"
    sha256 cellar: :any_skip_relocation, monterey:       "4359f2939cbe74d9c423defa38ef041574c12d7d223d7fb9b2e9665a4e382f60"
    sha256 cellar: :any_skip_relocation, big_sur:        "990ba2839f3c2ddf69e280e976463969d3274410f1a84a90e00a6a9b0f5cef35"
    sha256 cellar: :any_skip_relocation, catalina:       "acd49e52b73f82c2cab4a77f46e99e0f69f856dc43cbf03f775ab58b44e78d6b"
    sha256 cellar: :any_skip_relocation, mojave:         "800714b1d0f11a8fc52b070046aa3a5aaf99883f9320d9a233ffabf801ae2996"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2741db5b51e3d5cce2e16a2e200a5ac071d8ddb76255a3a4ae5b1752ec9cb33b"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    mkdir "test" do
      touch %w[a b c]
      ten_minutes_ago = Time.new - 600
      File.utime(ten_minutes_ago, ten_minutes_ago, "a")
      system "#{sbin}/tmpwatch", "2m", Pathname.pwd
      assert_equal %w[b c], Dir["*"].sort
    end
  end
end
