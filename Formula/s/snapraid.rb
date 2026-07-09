class Snapraid < Formula
  desc "Backup program for disk arrays"
  homepage "https://www.snapraid.it/"
  url "https://github.com/amadvance/snapraid/releases/download/v14.7/snapraid-14.7.tar.gz"
  sha256 "fe4c71d444bade85fe390d2a58de1ea34b53109278b96fb19bc9ac9133eb07ff"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "44522a7f91beeeb25ae826c218b3afb24386acaf6ee3ed9e22151ecd71c7e668"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2098bec036d7ebc740cf6d083229b9239e1c8e40c40621d60c09c0cc8bf2fbc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05d3023214a1474930751408c5944316b9c70ad81573ebcf4abbfd7ad0e100e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6876e29f80680b4fd01df795efaf189a037231847f641f05cb334a9a1305369"
    sha256 cellar: :any,                 arm64_linux:   "ae0858d82041c16c440ccca9e784a38712605fa2bc6e661063a66e2e1eba8be1"
    sha256 cellar: :any,                 x86_64_linux:  "8212a5017f0a09f0397003aff527787d55f809dab67a00b426b894b5c1880185"
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
