class Snapraid < Formula
  desc "Backup program for disk arrays"
  homepage "https://www.snapraid.it/"
  url "https://github.com/amadvance/snapraid/releases/download/v13.0/snapraid-13.0.tar.gz"
  sha256 "0282a9eec3301cd608dc45d9182b6d207f9fd4d25828c9deb329a015c77cb4e2"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19b050454ae04096be0285ebe515c2cc97ed39d46404e03d128d37b28726b471"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a38aa13933093f4bf281a8e0ad7079cd5b7ffaa85cdb55b9b70b456dc7d1fd36"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85b8ca325f1d873b8ebc0bf1c06b170ae3ae106ec677906d96ed77adf9499359"
    sha256 cellar: :any_skip_relocation, sonoma:        "955f3d5943b70e6798a18f339a9fae20c5a8404c67ed7447dd2f796623149fe0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a63c13b9c5ac924ef2f87bb2e7f44cc1e05810b3e58dd2b338039c7614ecf1a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4277c65597f58d2f996bd106b71249dd1c7ed7e39b990e2f9cb887d39993b8cf"
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
