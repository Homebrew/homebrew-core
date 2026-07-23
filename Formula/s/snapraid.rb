class Snapraid < Formula
  desc "Backup program for disk arrays"
  homepage "https://www.snapraid.it/"
  url "https://github.com/amadvance/snapraid/releases/download/v14.9/snapraid-14.9.tar.gz"
  sha256 "40c216979d9d9853248060497341f74feaa07c8ae15927b6b14972c4f9d143d5"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8c45f3a195ad37074eebfcd0c121c7ac9794ccd6e54b6fd5c0f779d5c54fa621"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9bea8de25bd0326627001705a2353c2047edbdc498b6c03a5f7735b8a7cdf94c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "000c32f8f7c73aa7397c739f83a9029cc89ea283d0d580a5a824deb0f62396d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "5bc53566aecfc56260fd71f1aa88819231d3080e2bffefb33e14913913e2b102"
    sha256 cellar: :any,                 arm64_linux:   "949f6a661f3f93f85bcdc352c6ad04a4788198ffd3e890cdd4ac793ecec3bf72"
    sha256 cellar: :any,                 x86_64_linux:  "0839c5c8510755baec256e44ad0eacd81edcd2eada96aae306095bdf76ece05e"
  end

  head do
    url "https://github.com/amadvance/snapraid.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snapraid --version")
  end
end
