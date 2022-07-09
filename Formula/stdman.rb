class Stdman < Formula
  desc "Formatted C++ stdlib man pages from cppreference.com"
  homepage "https://github.com/jeaye/stdman"
  url "https://github.com/jeaye/stdman/archive/2022.02.01.tar.gz"
  sha256 "84d36791514f20a814f1530e9f4e6ff67e538e0c9b3ef25db4b007f9861c4890"
  license "MIT"
  version_scheme 1
  head "https://github.com/jeaye/stdman.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0284a38dc221bb0b312253f1c40e01adf9809e8c6de55a24f754156c7ccd9bc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "16050a224d943282baca2789d32503919d0ebf6051b780e4f3ff85a2d7b0cf32"
    sha256 cellar: :any_skip_relocation, monterey:       "44f5fd941d1fd0e2e50174c070c2b4ddd288f2c2c83e9688817d3d29e7bc36ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "4ede76c9b03126b5fe3d03821547fd1ea2c24f625531dc090943fb2fdaccb20b"
    sha256 cellar: :any_skip_relocation, catalina:       "e672c1074a4c594acd0af1816c115a53d56209244c9a33251bf9bacbf4710af6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bcdb9672c7ef857b46ff0e722390aedd74132b7e7b8dc6b12ad7c051ea124e95"
  end

  on_linux do
    depends_on "man-db" => :test
  end

  # Preserve timestamps when doing `make install`.
  # This helps ensure uniform bottles across builds.
  # https://github.com/jeaye/stdman/pull/49
  patch do
    url "https://github.com/jeaye/stdman/commit/862e5132c18275661c468083baeab42dc4c335f2.patch?full_index=1"
    sha256 "8b2c785fc859e31fcb8c58884eff64c371bb9afd001979ad1158517c77ea1041"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    man = OS.mac? ? "man" : "gman"
    system man, "-w", "std::string"
  end
end
