class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v2.9.2/xmake-v2.9.2.tar.gz"
  sha256 "1f617b6a4568c7eb3e8ab0f3a67c16989245adc547e3a7d1fd861acb308fb5b2"
  license "Apache-2.0"
  head "https://github.com/xmake-io/xmake.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "803e687ffdd401f8240ed14318a4413a17d662bbf3938709b881b5915af7e5a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "22550e62841984ce31485e924ce7e28a3661aabdd680372d49e8096a7f255e71"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36e67c1a86957f80eef972222819210a6439d4c6ca4f4ca11346b2b54df0a7ad"
    sha256 cellar: :any_skip_relocation, sonoma:         "e8c4276a1314cfbd0a0aa59ee5051c5cee456005f5e0d90baa954c4d85c86dd8"
    sha256 cellar: :any_skip_relocation, ventura:        "4a0c3ed1ce6628a9163e71193bba16e9b332fb0e66d47e79a57817ffd4dbeaf9"
    sha256 cellar: :any_skip_relocation, monterey:       "2b373aec7f4302bb166d3d63373ecc9d03575e6d11e5bf463dce9ae090f9010b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "feb607aebbd9a4be305045997c094b20a153c28856d7ef6e9818871a03a702a3"
  end

  uses_from_macos "ncurses"

  on_linux do
    depends_on "readline"
  end

  def install
    system "./configure"
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    ENV.delete "CPATH"
    system bin/"xmake", "create", "test"
    cd "test" do
      system bin/"xmake"
      assert_equal "hello world!", shell_output("#{bin}/xmake run").chomp
    end
  end
end
