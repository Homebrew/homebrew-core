class Snapraid < Formula
  desc "Backup program for disk arrays"
  homepage "https://www.snapraid.it/"
  url "https://github.com/amadvance/snapraid/releases/download/v14.3/snapraid-14.3.tar.gz"
  sha256 "29cb416eda9beac436c2994543938c01f28555a11a24dedfe102677c9669080a"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "138e6bd4b42acd5e4b42239036749c33d526fb6323f31a7b3ab2cf5286e065e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69fd27957de89813b47870b2119157e7aacb77e6a0defb36ff4d6a0bf018c597"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7610a0960f80a741fa30c453dca2e54dfd8096b40b108a88802b5a4797a511d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ab27468e20247f51c173ce4f573612dc921ad381deffe973edf081e588cb275"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "050919daa6eadeeca4920fb18eac5ab747467ba2e144ed25f78df753b550b9eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d74a62ca3da777ebbbd4051aacd100657c301f4c96de754bb3db188bf1185fd8"
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
