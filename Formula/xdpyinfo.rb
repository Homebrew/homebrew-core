class Xdpyinfo < Formula
  desc "X.Org: Utility for displaying information about an X server"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/app/xdpyinfo-1.3.2.tar.bz2"
  sha256 "30238ed915619e06ceb41721e5f747d67320555cc38d459e954839c189ccaf51"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "ff2ad33679d6a717493607a23d89b8a61c3a0311f58435ae74dcf50efd44ea9d"
    sha256 cellar: :any,                 arm64_big_sur:  "233966c398633a07136501eab8fc263aaa97232c0fe27e76e8eb1fa59ed5440e"
    sha256 cellar: :any,                 monterey:       "86fcd00824eabdc1c808663db7fc37ebc7b67e231ab038cc4f2383717a9a0835"
    sha256 cellar: :any,                 big_sur:        "128f9ce7c4fad4a7bdc313c02c7c2324fa311845cc6ccaf9e19cc835bbef83e6"
    sha256 cellar: :any,                 catalina:       "dfb295a0259be51cd1ec75a16bda4582608569ad098a37ad257818616f70b81e"
    sha256 cellar: :any,                 mojave:         "2f9c704633a4a7d7df952f4874a16bae0cc8890e6ba1fdf7cd1654bb4cad01c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ad0f419da3316e1c46cb7f89af895d4ab2b7612a7806dba861b733b34b4b72a"
  end

  depends_on "pkg-config" => :build
  depends_on "libx11"
  depends_on "libxcb"
  depends_on "libxext"
  depends_on "libxtst"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
    ]
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    on_linux do
      # xdpyinfo:  unable to open display "".
      return if ENV["HOMEBREW_GITHUB_ACTIONS"]
    end

    assert_match("xdpyinfo #{version}", shell_output("DISPLAY= xdpyinfo -version 2>&1"))
  end
end
