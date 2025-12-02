class Tmpreaper < Formula
  desc "Clean up files in directories based on their age"
  homepage "https://packages.debian.org/sid/tmpreaper"
  url "https://ftp.debian.org/debian/pool/main/t/tmpreaper/tmpreaper_1.6.18.tar.xz"
  sha256 "2ae7de0775b49abd222d09ad71360d795b40aa7c31253363e64c182966a37c00"
  license "GPL-2.0-only"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/t/tmpreaper/"
    regex(/href=.*?tmpreaper[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30aab94f88a07061601a3333b691fc941c683b7936e955bac83de7c48f97c482"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a134d1977bb0607e2b93a5e35fbfa2979310e58042604a858f91ebe5bef87b4f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f35e698b40aab74ca34120de8327b518a4770ec4e07d1fb44d6d46a7c589cb68"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aa1b0ab8c36bf2ba8f9bbb2d9be36eaaf5395c9d6f2a9a904ad25ebfbcbaa783"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0e097e2544698d880b83f4a8284105917b8f09628484ead21888bd31b5051cb"
    sha256 cellar: :any_skip_relocation, ventura:       "f2810c2ef580d6317db1e5089a75f6fad8542e7d9f6798d7a3cfd75ab4eb1024"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d4eb5e686f3ec01a8fec3b07930dc37c0353d816bf9ce845f3131bd9ef87ff5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c0688fa5f46502a1b12339adaf4d7af1a746046dea9f400729968265944f1fe"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  on_linux do
    depends_on "e2fsprogs"
    depends_on "util-linux"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}"
    system "make", "install"
  end

  test do
    touch "removed"
    sleep 3
    touch "not-removed"
    system "#{sbin}/tmpreaper", "2s", "."
    refute_path_exists testpath/"removed"
    assert_path_exists testpath/"not-removed"
  end
end
